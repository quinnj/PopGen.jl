@inline function FST_global(data::PopData)
    # observed/expected het per locus per pop
    het_df = DataFrames.combine(
        groupby(data.loci, [:locus, :population]),
        :genotype => nonmissing => :n,
        :genotype => hetero_o => :het_obs,
        :genotype => (i -> hetero_e(i)) => :het_exp,
        :genotype => allele_freq => :alleles
    )
    # collapse down to retrieve averages and counts
    n_df = DataFrames.combine(
        [:het_obs, :het_exp, :n, :alleles] => (o,e,n,alleles) -> (
            count = sum(.!iszero.(n)),
            mn = sum(.!iszero.(n)) ./ sum(reciprocal.(n)),
            HS = mean(skipmissing(gene_diversity_nei87.(e,o,sum(.!iszero.(n)) ./ sum(reciprocal.(n))))),
            Het_obs = mean(skipmissing(o)),
            avg_freq = sum(values(avg_allele_freq(alleles)).^2)
            ),
        groupby(het_df, :locus)
    )

    HT = mean(@inbounds 1.0 .- n_df.avg_freq .+ (n_df.HS ./ n_df.mn ./ n_df.count) - (n_df.Het_obs ./ 2.0 ./ n_df.mn ./ n_df.count))
    DST = mean(@inbounds HT .- n_df.HS)
    DST′ = mean(@inbounds n_df.count ./ (n_df.count .- 1) .* DST)
    HT′ = mean(@inbounds n_df.HS .+ DST′)

    return Dict{Symbol, Float64}(
        :FST => DST / HT,
        :FST′ => DST′ / HT′
    )
end

function FST_locus(data::PopData)
    # observed/expected het per locus per pop
    het_df = DataFrames.combine(
        groupby(data.loci, [:locus, :population]),
        :genotype => nonmissing => :n,
        :genotype => hetero_o => :het_obs,
        :genotype => (i -> hetero_e(i)) => :het_exp,
        :genotype => allele_freq => :alleles
    )
    # collapse down to retrieve averages and counts
    n_df = DataFrames.combine(
        [:het_obs, :het_exp, :n, :alleles] => (o,e,n,alleles) -> (
            count = sum(.!iszero.(n)),
            mn = sum(.!iszero.(n)) ./ sum(reciprocal.(n)),
            HS = mean(skipmissing(gene_diversity_nei87.(e,o,sum(.!iszero.(n)) ./ sum(reciprocal.(n))))),
            Het_obs = mean(skipmissing(o)),
            avg_freq = sum(values(avg_allele_freq(alleles)).^2)
            ),
        groupby(het_df, :locus)
    )

    HT = 1.0 .- n_df.avg_freq .+ (n_df.HS ./ n_df.mn ./ n_df.count) - (n_df.Het_obs ./ 2.0 ./ n_df.mn ./ n_df.count)
    DST = HT .- n_df.HS
    DST′ = n_df.count ./ (n_df.count .- 1) .* DST
    HT′ = n_df.HS .+ DST′

    return Dict{Symbol, Vector{Float64}}(
        :FST => DST ./ HT,
        :FST′ => DST′ ./ HT′
        )
end


"""
    f_stat_p(data::PopObj; nperm::Int64)
Performs a permutation test (permuting individuals among populations) to calculate
p-values for F-statistics
"""
function f_stat_p(data::PopData; nperm::Int = 1000)
    tmp = deepcopy(data)
    observed = FST(data, by = "global")
    FST_p = 1.0
    FST′_p = 1.0
    #=
    perm_dict = Dict{Symbol,Vector{Float64}}(
        :FST => Vector{Float64}(undef, nperm-1),
        :FST′ => Vector{Float64}(undef, nperm-1)
    )
    =#
    @inbounds for n in 1:nperm-1
        permute_samples!(tmp)
        permuted = FST(tmp, by = "global")
        FST_p += (observed[:FST] < permuted[:FST])
        FST′_p += (observed[:FST′] < permuted[:FST])
    end

    return (FST_p / nperm , FST′_p / nperm)
    #=
    for (k,v) in perm_dict
        observed[k] = (1 + sum(observed[k] .<= v))/nperm
    end
    =#
    return observed
end


function f_stat_old(data::PopData; nperm::Int = 1000)
    tmp = deepcopy(data)
    observed = FST_global(data)
    perm_dict = Dict{Symbol,Vector{Float64}}(
        :FST => Vector{Float64}(undef, nperm-1),
        :FST′ => Vector{Float64}(undef, nperm-1)
    )

    @inbounds for n in 1:nperm-1
        permute_samples!(tmp)
        tmp_f = FST_global(tmp)
        perm_dict[:FST][n] = tmp_f[:FST]
        perm_dict[:FST′][n] = tmp_f[:FST′]
    end

    @inbounds for (k,v) in perm_dict
        observed[k] = (1 + sum(observed[k] .<= v))/nperm
    end
    return observed
end

julia> @btime f_stat_p(y, nperm = 1000)
  116.729 s (1310968334 allocations: 96.95 GiB)
