"""
    allele_freq(locus::T) where T<:GenoArray
Return a `Dict` of allele frequencies of a single locus in a `PopData`
object.
"""
@inline function allele_freq(locus::GenoArray)
    d = Dict{Int16,Float32}()
    flat_alleles = alleles(locus)
    len = length(flat_alleles)
    len == 0 && return d
    @inbounds @simd for allele in flat_alleles
        @inbounds d[allele] = get!(d, allele, 0) + 1/len
    end
    return d
end


"""
    allele_freq_vec(locus::T) where T<:GenoArray
Return a Vector of allele frequencies of a single locus in a `PopData`
object. Similar to `allele_freq()`, except it returns only the frequencies,
without the allele names, meaning they can be in any order. This is useful
for getting the expected genotype frequencies.
"""
@inline function allele_freq_vec(locus::GenoArray)
    flat_alleles = alleles(locus)
    len = length(flat_alleles)
    d = [count(i -> i == j, flat_alleles) for j in unique(flat_alleles)]
    return d ./ len
end

@inline function allele_freq_vec(::Missing)
    return missing
end

#TODO add to docs (API/AlleleFreq)
"""
    avg_allele_freq(allele_dicts::AbstractVector{T}) where T<:Dict{Int16,Float32}
Takes a Vector of Dicts generated by `allele_freq` and returns a Dict of the average
allele frequencies. This is typically done to calculate average allele frequencies
across populations.

***Example***
```
cats = nancycats();
alleles_df = DataFrames.combine(
    groupby(cats.loci, [:locus, :population]),
    :genotype => allele_freq => :alleles
);
DataFrames.combine(
    groupby(alleles_df, :locus),
    :alleles => (i -> sum(avg_allele_freq(i).^2)) => :avg_freq
)
```
"""
function avg_allele_freq(allele_dicts::AbstractVector{T}) where T<:Dict{Int16,Float32}
   sum_dict = Dict{Int16, Tuple{Float32, Int}}()
   # remove any dicts with no entries (i.e. from a group without that locus)
   allele_dicts = allele_dicts[length.(allele_dicts) .> 0]
   # create a list of all the alleles
   all_alleles = keys.(allele_dicts) |> Base.Iterators.flatten |> collect |> unique
   # populate the sum dict with allele frequency and n for each allele
   @inbounds for allele in all_alleles
       for allele_dict in allele_dicts
           sum_dict[allele] = get!(sum_dict, allele, (0., 0)) .+ (get!(allele_dict, allele, 0.), 1)
       end
   end
   avg_dict = Dict{Int16, Float32}()
   # collapse the sum dict into a dict of averages
   @inbounds for (key, value) in sum_dict
       freq_sum, n = value
       avg = freq_sum / n
       # drop zeroes
       if !iszero(avg)
           @inbounds avg_dict[key] = avg
       end
   end
   return avg_dict
end

"""
    allele_freq(data::PopData, locus::String; population::Bool = false)
Return a `Dict` of allele frequencies of a single locus in a `PopData`
object. Use `population = true` to return a table of allele frequencies
of that locus per population.
### Example
```
cats = nancycats()
allele_freq(cats, "fca8")
allele_freq(cats, "fca8", population = true)
```
"""
function allele_freq(data::PopData, locus::String, population::Bool=false)
    if !population
        data.loci[data.loci.locus .== locus, :genotype] |> allele_freq
    else
        tmp = groupby(data.loci[data.loci.locus .== locus, :], :population)
        DataFrames.combine(tmp, :genotype => allele_freq => :frequency)
    end
end


#TODO add to docs (API)
"""
    allele_freq(allele::Int, genos::T) where T<:GenoArray
Return the frequency of an `allele` from a vector of `genotypes`

### Example
```
using DataFramesMeta
ncats = nancycats();
ncats_sub @where(ncats.loci, :locus .== "fca8", :genotype .!== missing)
pop_grp = groupby(ncats_sub, :population)
DataFrames.combine(pop_grp, :genotype => (geno,) -> allele_freq(146, geno))
```
"""
function allele_freq(allele::Int, genos::T) where T<:GenoArray
    ploidy = (length.(genos) |> unique)[1]
    count(allele .== Base.Iterators.flatten(genos))/(ploidy*nonmissing(genos))
end

"""
    geno_count_observed(locus::T) where T<:GenoArray
Return a `Dict` of genotype counts of a single locus in a
`PopData` object.
"""
@inline function geno_count_observed(locus::T) where T<:GenoArray
    # conditional testing if all genos are missing
    all(ismissing.(locus)) && return missing
    d = Dict{Tuple, Float32}()
    @inbounds for genotype in skipmissing(locus)
        # sum up non-missing genotypes
        d[genotype] = get!(d, genotype, 0) + 1
    end
    return d
end

"""
    geno_count_expected(locus::T) where T<:GenoArray
Return a `Dict` of the expected genotype counts of a single locus in a
`PopData` object. Expected counts are calculated as the product of observed
allele frequencies multiplied by the number of non-missing genotypes.
"""
function geno_count_expected(locus::T) where T<:GenoArray
    #count number of non-missing genotypes in the locus
    n = nonmissing(locus)

    # Get expected number of genotypes in a locus
    ## get the observed allele frequencies
    allele_dict = allele_freq(locus)

    ## split the appropriate pairs into their own vectors
    alle, freq = string.(keys(allele_dict)), collect(values(allele_dict))
    #return alle, freq
    ## calculate expected genotype frequencies by multiplying all-by-all x n
    expected_genotype_freq = vec(freq * freq' .* n)

    ## regenerate genotypes by concatenating alleles and re-phasing them with
    ## same all-by-all approach
    alle = lpad.(alle, 4, "0")    # cheat by padding strings
    genos = phase.(vec(alle .* permutedims(alle)), Int16, 4)

    # reform genotype frequencies into a Dict
    expected = Dict{Tuple, Float64}()
    for (geno, freq) in zip(genos, expected_genotype_freq)
        expected[geno] = get!(expected, geno, 0) + freq
    end

    return expected
end


"""
    geno_freq(locus::T) where T<:GenoArray
Return a `Dict` of genotype frequencies of a single locus in a
`PopData` object.
"""
@inline function geno_freq(locus::T) where T<:GenoArray
    # conditional testing if all genos are missing
    all(ismissing.(locus)) && return missing
    d = Dict{Tuple, Float32}()
    @inbounds for genotype in skipmissing(locus)
        # sum up non-missing genotypes
        d[genotype] = get!(d, genotype, 0) + 1
    end
    total = values(d) |> sum    # sum of all non-missing genotypes
    [d[i] = d[i] / total for i in keys(d)] # genotype count/total
    return d
end


"""
    geno_freq(data::PopData, locus::String; population::Bool = false)
Return a `Dict` of genotype frequencies of a single locus in a `PopData`
object. Use `population = true` to return a table of genotype frequencies
of that locus per population.
### Example
```
cats = nancycats()
geno_freq(cats, "fca8")
geno_freq(cats, "fca8", population = true)
```
"""
function geno_freq(data::PopData, locus::String, population::Bool=false)
    if !population
        tmp = data.loci[data.loci.locus .== locus, :genotype]
        geno_freq(tmp)
    else
        tmp = data.loci[data.loci.locus .== locus, :]
        DataFrames.combine(groupby(tmp, :population), :genotype => geno_freq => :freq)
    end
end


"""
    geno_freq_expected(locus::T) where T<:GenoArray
Return a `Dict` of the expected genotype frequencies of a single locus in a
`PopData` object. Expected frequencies are calculated as the product of
observed allele frequencies.
"""
function geno_freq_expected(locus::T) where T<:GenoArray
    # Get expected number of genotypes in a locus
    ## get the observed allele frequencies
    allele_dict = allele_freq(locus)

    ## split the appropriate pairs into their own vectors
    alle, freq = string.(keys(allele_dict)), collect(values(allele_dict))
    #return alle, freq
    ## calculate expected genotype frequencies by multiplying all-by-all
    expected_genotype_freq = vec(freq * freq')

    ## regenerate genotypes by concatenating alleles and re-phasing them with
    ## same all-by-all approach
    alle = lpad.(alle, 4, "0")    # cheat by padding strings
    genos = phase.(vec(alle .* permutedims(alle)), Int16, 4)

    # reform genotype frequencies into a Dict
    expected = Dict{Tuple, Float64}()
    for (geno, freq) in zip(genos, expected_genotype_freq)
        expected[geno] = get!(expected, geno, 0) + freq
    end

    return expected
end

"""
    geno_freq_expected(data::PopData, locus::String; population::Bool = false)
Return a `Dict` of expected genotype frequencies of a single locus in a
`PopData` object. Use `population = true` to return a table of expected genotype
frequencies of that locus per population.
### Example
```
cats = nancycats()
geno_freq_expeced(cats, "fca8")
geno_freq_expected(cats, "fca8", population = true)
```
"""
function geno_freq_expected(data::PopData, locus::String, population::Bool=false)
    if !population
        tmp = data.loci[data.loci.locus .== locus, :genotype]
        geno_freq_expected(tmp)
    else
        tmp = data.loci[data.loci.locus .== locus, :]
        DataFrames.combine(groupby(tmp, :population), :genotype => geno_freq_expected => :freq)
    end
end
