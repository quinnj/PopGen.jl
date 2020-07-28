export QuellerGoodnight, Ritland, Lynch, LynchRitland, LynchLi, LiHorvitz, Moran, Blouin, Loiselle, Wang, relatedness

"""
    Blouin(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Allele sharing index described by Blouin (1996)

- Single Locus Equation: The number of alleles shared between individuals over ploidy.
    - If both allele positions are shared (e.g. AA x AA or AB x AB) then 1
    - If one allele position is shared (e.g. AB x AC) then 0.5
    - If neither allele position is shared (e.g. AB x CD) then 0
- How to combine multiple loci: Single locus estimates are simply averaged together
- Assumes no inbreeding

Blouin, M. S., Parsons, M., Lacaille, V., & Lotz, S. (1996). Use of microsatellite loci to classify individuals by relatedness. Molecular ecology, 5(3), 393-401.
"""
function Blouin(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    isempty(locus_names) && return missing

    Mxy = Vector{Float64}(undef, length(locus_names))
    loc_id = 0

    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        loc_id += 1
        i,j = gen1
        k,l = gen2

        Mxy[loc_id] = (((i ∈ gen2) & (k ∈ gen1)) + ((j ∈ gen2) & (l ∈ gen1))) / 2
    end
    return mean(Mxy)
end


"""
    LiHorvitz(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Allele sharing index described by Li and Horvitz (1953)

-Single Locus Equation: If all alleles are the same between individuals (eg. AA x AA) then 1.
    - If two alleles are shared between individuals (eg.  AA x AB or AB x AB) then 0.5.
    - If only one allele is shared between individuals (eg. AB x AC) then 0.25.
    - If no alleles are shared (eg. AB x CD) then 0.
- How to combine multiple loci: Single locus estimates are simply averaged together
- Assumes no inbreeding

Li, C. C., & Horvitz, D. G. (1953). Some methods of estimating the inbreeding coefficient. American journal of human genetics, 5(2), 107.
"""
function LiHorvitz(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    isempty(locus_names) && return missing

    Bxy = Vector{Float64}(undef, length(locus_names))

    loc_id = 0
    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        loc_id += 1
        i,j = gen1
        k,l = gen2

        Bxy[loc_id] = sum([i, j] .∈ [k,l]') / 4
    end
    return mean(Bxy)
end


"""
    Loiselle(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Calculates the moments based estimator of pairwise relatedness using the estimator propsed by
Loiselle et al (1995) and modified to individual dyads by Heuertz et al. (2003).

- Multiple Locus Equation:
- Assumes no inbreeding

See equations 22 in: Wang(2017) for variant of estimator used

Loiselle, B. A., Sork, V. L., Nason, J., & Graham, C. (1995). Spatial genetic structure of a tropical understory shrub, <i>Psychotria officinalis</i> (Rubiaceae). American journal of botany, 82(11), 1420-1425.
Heuertz, M., Vekemans, X., Hausman, J. F., Palada, M., & Hardy, O. J. (2003). Estimating seed vs. pollen dispersal from spatial genetic structure in the common ash. Molecular Ecology, 12(9), 2483-2495.
Wang, J. (2017). Estimating pairwise relatedness in a small sample of individuals. Heredity, 119(5), 302-313.
"""
function Loiselle(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    isempty(locus_names) && return missing
    d_kw = Dict(kwargs...)
    numerator1 = 0.0
    denominator1 = 0.0

    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        for allele in keys(alleles[loc])
            fq = alleles[loc][allele]
            numerator1 += ((sum(gen1 .== allele) / 2.0) - fq) * ((sum(gen2 .== allele) / 2.0) - fq)
            denominator1 += fq * (1.0 - fq)
        end
    end
    return numerator1 / denominator1 + 2.0 / (2 * d_kw[:n_samples] - 1)
end


"""
    Lynch(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Allele sharing index described by Lynch (1988)

- Single Locus Equation: If all alleles are the same between individuals (eg. AA x AA) then 1.
    - If both individuals are heterozygous with the same alleles or one is homozygous for the shared allele (eg. AB x AB or AA x AB) then 0.75.
    - If only one allele is shared between individuals (eg. AB x AC) then 0.5.
    - If no alleles are shared (eg. AB x CD) then 0.
- How to combine multiple loci: Single locus estimates are simply averaged together
- Assumes no inbreeding

Lynch, M. (1988). Estimation of relatedness by DNA fingerprinting. Molecular biology and evolution, 5(5), 584-599.
"""
function Lynch(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    isempty(locus_names) && return missing

    Sxy = Vector{Float64}(undef, length(locus_names))
    loc_id = 0

    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        loc_id += 1
        i,j = gen1
        k,l = gen2

        Sxy[loc_id] = ((i ∈ gen2) + (j ∈ gen2) + (k ∈ gen1) + (l ∈ gen1)) / 4
    end
    return mean(Sxy)
end


"""
    LynchLi(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Calculates the moments based estimator of pairwise relatedness by Lynch (1988) & improved by Li et al. (1993).

- Single Locus Equation:
- How to combine multiple loci: Sum the difference between observed and expected similarity across all loci and then divide by the sum of 1 - the expected similarity
- Assumes no inbreeding

See equations 13 - 16 in Wang (2017) for variant of estimator used

Li, C. C., Weeks, D. E., & Chakravarti, A. (1993). Similarity of DNA fingerprints due to chance and relatedness. Human heredity, 43(1), 45-52.
Wang, J. (2017). Estimating pairwise relatedness in a small sample of individuals. Heredity, 119(5), 302-313.
"""
function LynchLi(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    isempty(locus_names) && return missing

    numerator1 = 0.0
    denominator1 = 0.0

    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        a,b = gen1
        c,d = gen2

        Sxy = (0.5) * (((a == c) + (a == d) + (b == c) + (b == d)) / (2.0 * (1.0 + (a == b))) + ((a == c) + (a == d) + (b == c) + (b == d)) / (2.0 * (1.0 + (c == d))))
        #TODO Change to unbiased formulation (eq 25)
        S0 = 2.0 * sum(values(alleles[loc]) .^ 2) - sum(values(alleles[loc]) .^ 3)

        numerator1 += Sxy - S0
        denominator1 += 1.0 - S0
    end
    return numerator1 / denominator1
end


"""
    LynchRitland(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Calculates the moments based estimator of pairwise relatedness by Lynch and Ritland (1999).

- Single Locus Equation:
- How to combine multiple loci: Weighted average of each term seperately weighted by the sample variance (assuming zero relatedness) and subsequently divided by the average sampling variance
- Assumes no inbreeding

See equation 10 in Wang (2017) for variant of estimator used

Lynch, M., & Ritland, K. (1999). Estimation of pairwise relatedness with molecular markers. Genetics, 152(4), 1753-1766.
Wang, J. (2017). Estimating pairwise relatedness in a small sample of individuals. Heredity, 119(5), 302-313.
"""
function LynchRitland(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    isempty(locus_names) && return missing

    numerator1 = 0.0
    denominator1 = 0.0

    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        a,b = gen1
        c,d = gen2
        fq_a, fq_b, fq_c, fq_d = map(i -> alleles[loc][i], (a,b,c,d))

        n1 = fq_a * ((b == c) + (b == d)) + fq_b * ((a == c) + (a == d)) - 4.0 * fq_a * fq_b
        n2 = fq_c * ((d == a) + (d == b)) + fq_d * ((c == a) + (c == b)) - 4.0 * fq_c * fq_d

        d1 = 2.0 * (1.0 + (a == b)) * (fq_a + fq_b) - 8.0 * fq_a * fq_b
        d2 = 2.0 * (1.0 + (c == d)) * (fq_c + fq_d) - 8.0 * fq_c * fq_d


        WL1 = ((1 + (a == b)) * (fq_a + fq_b) - 4 * fq_a * fq_b) / (2 * fq_a * fq_b)
        WL2 = ((1 + (c == d)) * (fq_c + fq_d) - 4 * fq_c * fq_d) / (2 * fq_c * fq_d)

        numerator1 += ((n1 / d1) * WL1 + (n2 / d2) * WL2)
        denominator1 += (WL1 + WL2) / 2.0
    end
    return numerator1 / denominator1
end


"""
    Moran(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Reinterpretation of Moran's I (commonly used for spatial autocorrelation) to estimate genetic relatedness
by Hardy and Vekemans (1999)

- Multiple Locus Equation:
- Assumes no inbreeding

Hardy, O. J., & Vekemans, X. (1999). Isolation by distance in a continuous population: reconciliation between spatial autocorrelation analysis and population genetics models. Heredity, 83(2), 145-154.
"""
function Moran(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    #TODO NEED TO CHECK TO CONFIRM EQUATIONS
    isempty(locus_names) && return missing

    numerator1 = 0.0
    denominator1 = 0.0

    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        for allele in keys(alleles[loc])
            fq = alleles[loc][allele]
            numerator1 += ((sum(gen1 .== allele) / 2.0) - fq) * ((sum(gen2 .== allele) / 2.0) - fq)
            #denominator1 += ((sum(gen1 .== allele) / 2.0) - fq)^2
            denominator1 += (((sum(gen1 .== allele) / 2.0) - fq)^2 + ((sum(gen2 .== allele) / 2.0) - fq)^2) / 2.0
        end
        #denominator1 += (1 / (length(alleles[loc]) - 1))
    end
    return (numerator1 / denominator1)
end

function Moran_experimental(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    #TODO NEED TO CHECK TO CONFIRM EQUATIONS
    isempty(locus_names) && return missing

    numerator1 = Vector{Float64}(undef, length(locus_names))
    denominator1 = similar(numerator1)

    numerator1 = numerator1 .* 0.0
    denominator1 = denominator1 .* 0.0

    idx = 0
    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        idx += 1
        for allele in keys(alleles[loc])
            fq = alleles[loc][allele]
            numerator1[idx] += ((sum(gen1 .== allele) / 2.0) - fq) * ((sum(gen2 .== allele) / 2.0) - fq)
            denominator1[idx] += (((sum(gen1 .== allele) / 2.0) - fq)^2) #+ ((sum(gen2 .== allele) / 2.0) - fq)^2)  / 2
        end
        denominator1[idx] += (1 / (length(alleles[loc]) - 1))
    end

    return mean(numerator1 ./ denominator1)
end

"""
    QuellerGoodnight(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Calculates the moments based estimator of pairwise relatedness developed by Queller & Goodnight (1989).

- Single Locus Equation:
- How to combine multiple loci:
    - Multiple loci are combined by independently summing the two numerator and two denominator terms before performing the final division and averaging the two components.
- Assumes no inbreeding
See equation 3 in Wang(2017) for variant of estimator used.

Queller, D. C., & Goodnight, K. F. (1989). Estimating relatedness using genetic markers. Evolution, 43(2), 258-275.
Wang, J. (2017). Estimating pairwise relatedness in a small sample of individuals. Heredity, 119(5), 302-313.
"""
function QuellerGoodnight(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    isempty(locus_names) && return missing

    numerator1 = 0.0
    numerator2 = 0.0
    denominator1 = 0.0
    denominator2 = 0.0

    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        a,b = gen1
        c,d = gen2
        ident = ((a == c) + (a == d) + (b == c) + (b == d))
        fq_a, fq_b, fq_c, fq_d = map(i -> alleles[loc][i], (a,b,c,d))

        numerator1 += ident - 2.0 * (fq_a + fq_b)
        numerator2 += ident - 2.0 * (fq_c + fq_d)

        denominator1 += (2.0 * (1.0 + (a==b) - fq_a - fq_b))
        denominator2 += (2.0 * (1.0 + (c==d) - fq_c - fq_d))
    end
    return (numerator1/denominator1 + numerator2/denominator2)/2.0
end


"""
    Ritland(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Calculates the moments based estimator of pairwise relatedness proposed by Li and Horvitz (1953) and implemented/made popular by Ritland (1996).

- Single Locus Equation:
- How to combine multiple loci: A weighted average of individual locus specific estimates weighted by sampling variance
- Assumes no inbreeding

See equation 7 in: Wang (2017) for variant of estimator used

Ritland, K. (1996). Estimators for pairwise relatedness and individual inbreeding coefficients. Genetics Research, 67(2), 175-185.
Wang, J. (2017). Estimating pairwise relatedness in a small sample of individuals. Heredity, 119(5), 302-313.
"""
function Ritland(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    isempty(locus_names) && return missing

    numerator1 = 0.0
    denominator1 = 0.0

    for (loc,gen1,gen2) in zip(locus_names, ind1, ind2)
        a,b = gen1
        c,d = gen2

        A = ((alleles[loc] |> length) - 1)

        R = 0.0
        for i in unique((a,b,c,d))
            # Individual locus relatedness value (eq 7 in paper)
            R += ((((a == i) + (b == i)) * ((c == i) + (d == i))) / (4.0 * alleles[loc][i]))
        end
        R = (2.0 / A) * (R - 1.0)
        # numerator for weighted combination of loci
        numerator1 += (R * A)
        # denominator for weighted combination of loci
        denominator1 += A
    end
    return numerator1 / denominator1
end

### Wang 2002 helper functions ###
function a_wang_base(m::Int, alleles::Dict)
    sum(values(alleles) .^ m)
end

function a_wang(N::Int, alleles::Dict)
    #unbiased estimator
    a = 0.0

    b = (N * a_wang_base(2, alleles) - 1) / (N - 1)

    c = (N^2 * a_wang_base(3, alleles) - 3 * (N - 1) * b - 1) / ((N - 1) * (N - 2))

    d = (N^3 * a_wang_base(4, alleles) - 6 * (N - 1) * (N - 2) * c - 7 * (N - 1) * b - 1) / (N^3 - 6 * N^2 + 11 * N - 6)

    return [a, b, c, d]
end


"""
Wang(ind1::GenoArray, ind2::GenoArray, locus_names::Vector{Symbol}; alleles::NamedTuple)
Calculates the moments based estimator of pairwise relatedness by Wang (2002).

-Single Locus Equation:
-How to combine multiple loci: Each individual locus subcomponent (b-g) and each genotypic state (P1-P3) is averaged weighted by the average similarity of unrelated dyads at each locus. Then the values of V, Φ, Δ, and r are calculated

-Assumes no inbreeding
-Corrected for sampling bias in allele frequencies to get an unbiased estimator

Wang, J. (2002). An estimator for pairwise relatedness using molecular markers. Genetics, 160(3), 1203-1215.
"""
function Wang(ind1::T, ind2::T, locus_names::Vector{Symbol}, alleles::U; kwargs...) where T <: GenoArray where U <: NamedTuple
    #TODO NEED TO CHECK TO CONFIRM EQUATIONS
    isempty(locus_names) && return missing
    kw_dict = Dict(kwargs...)
    P1 = Vector{Float64}(undef, length(locus_names))
    P2, P3, P4, u, b, c, d, e, f, g = map(i -> similar(P1), 1:10)
    loc_id = 0

    for (loc,gen1,gen2, N) in zip(locus_names, ind1, ind2, kw_dict[:loc_n])
        loc_id += 1
        i,j = gen1
        k,l = gen2

        #N = nonmissing(data.loci[data.loci.locus .== string(loc), :genotype])

        a = a_wang(2 * N, alleles[loc])
        a2_sq = a[2] ^ 2

        u[loc_id] = 2 * a[2] - a[3]

        # Which category of dyad
        Sxy = ((i ∈ gen2) + (j ∈ gen2) + (k ∈ gen1) + (l ∈ gen1)) / 4

        # Both alleles shared between individuals either the same or different
        P1[loc_id] = 1.0 * (Sxy == 1)
        # One allele shared between individuals and one is homozygous for that allele
        P2[loc_id] = 1.0 * (Sxy == (3/4))
        # One allele shared with the other two being unique
        P3[loc_id] = 1.0 * (Sxy == (1/2))
        P4[loc_id] = 1.0 * ((P1 + P2 + P3) == 0)

        b[loc_id] = (2.0 * a2_sq - a[4])
        c[loc_id] = (a[2] - 2.0 * a2_sq + a[4])
        d[loc_id] = (4.0 * (a[3] - a[4]))
        e[loc_id] = (2.0 * (a[2] - 3.0 * a[3] + 2.0 * a[4]))
        f[loc_id] = (4.0 * (a[2] - a2_sq - 2.0 * a[3] + 2.0 * a[4]))
        g[loc_id] = (1.0 - 7.0 * a[2] + 4.0 * a2_sq + 10.0 * a[3] - 8.0 * a[4])

    end
    #return (1 / (sum(1/u) * u)) * r
    w = (1 / (sum(1/u) * u))


    P1 = w * P1
    P2 = w * P2
    P3 = w * P3

    b = w * b
    c = w * c
    d = w * d
    e = w * e
    f = w * f
    g = w * g

    #Eq 11
    V = (1.0 - b)^2 * (e^2 * f + d * g^2) -
        (1.0 - b) * (e * f - d * g)^2 +
        2.0 * c * d * f * (1.0 - b) * (g + e) +
        c^2 * d * f * (d + f)

    #Eq 9
    Φ = (d * f * ((e + g) * (1.0 - b) + c * (d + f)) * (P1 - 1.0) +
        d * (1.0 - b) * (g * (1.0 - b - d) + f * (c + e)) * P3 +
        f * (1.0 - b) * (e * (1.0 - b - f) + d * (c + g)) * P2) / V

    #Eq 10
    Δ = (c * d * f * (e + g) * (P1 + 1.0 - 2 * b) +
        ((1.0 - b) * (f * e^2 + d * g^2) - (e * f - d * g)^2) * (P1 - b) +
        c * (d * g - e * f) * (d * P3 - f * P2) - c^2 * d * f * (P3 + P2 - d - f) -
        c * (1.0 - b) * (d * g * P3 + e * f * P2)) / V

    r = (Φ/2.0 + Δ)
    return r
end

#Bootstrap Utilities
function bootstrap_locus(data::PopData, method::F, ind1::String, ind2::String, iterations::Int64, allele_frq::NamedTuple) where F
    relate_vec_boot = Vector{Union{Missing,Float64}}(undef, iterations)
    n_samples = length(samples(data))
    loc_names = loci(data)
    n_loc = length(loci(data))
    for b in 1:iterations
        loci_sample = sample(loc_names, n_loc)
        n_per_loci = map(i -> nonmissing(data, i), loci_sample)
        geno1_sample = map(i -> get_genotype(data, sample = ind1, locus = i), loci_sample)
        geno2_sample = map(i -> get_genotype(data, sample = ind2, locus = i), loci_sample)
        loc_samp,gen_samp1,gen_samp2, n_per_loc = collect.(skipmissings(Symbol.(loci_sample), geno1_sample, geno2_sample, n_per_loci))

        relate_vec_boot[b] = method(gen_samp1, gen_samp2, loc_samp, allele_frq, loc_n = n_per_loc, n_samples = n_samples)
    end
    return relate_vec_boot
end

function bootstrap_summary(boot_out::Vector{Union{Missing, Float64}}, B::Int64, width::Tuple{Float64, Float64})
    Mean = mean(boot_out)
    Median = median(boot_out)
    SE = sqrt(sum((boot_out - (boot_out / B)).^2) / (B - 1))
    quants = quantile(boot_out, width)

    return Mean, Median, SE, quants
end


function relatedness_no_boot(data::PopData, sample_names::Vector{String}; method::F) where F
    loci_names = Symbol.(loci(data))
    n_samples = length(samples(data))
    sample_pairs = pairwise_pairs(sample_names)
    n_per_loci = DataFrames.combine(groupby(data.loci, :locus), :genotype => nonmissing => :n)[:, :n]
    allele_frequencies = allele_freq(data)
    relate_vecs = map(i -> Vector{Union{Missing,Float64}}(undef, length(sample_pairs)), 1:length(method))
    shared_loci = Vector{Int}(undef, length(sample_pairs))
    p = Progress(length(sample_pairs), dt = 1, color = :blue)
    popdata_idx = groupby(data.loci, :name)
    idx = 0
    @inbounds for (sample_n, ind1) in enumerate(sample_names[1:end-1])
        geno1 = popdata_idx[(ind1,)].genotype
        @inbounds @sync Base.Threads.@spawn for ind2 in sample_names[sample_n+1:end]
            idx += 1

            geno2 = popdata_idx[(ind2,)].genotype

            # filter out loci missing in at least one individual in the pair
            loc,gen1,gen2, n_per_loc = collect.(skipmissings(loci_names, geno1, geno2, n_per_loci))

            # populate shared_loci array
            @inbounds shared_loci[idx] = length(loc)
            @inbounds [relate_vecs[i][idx] = mth(gen1, gen2, loc, allele_frequencies, loc_n = n_per_loc, n_samples = n_samples) for (i,mth) in enumerate(method)]

            update!(p, idx)
        end
    end
    method_colnames = [Symbol("$i") for i in method]
    out_df = DataFrame(:sample_1 => getindex.(sample_pairs, 1), :sample_2 => getindex.(sample_pairs, 2), :n_loci => shared_loci)
    [out_df[:, mth] = relate_vecs[i] for (i, mth) in enumerate(method_colnames)]
    return out_df
end


function relatedness_bootstrap(data::PopData, sample_names::Vector{String}; method::F, iterations::Int = 100, interval::Tuple{Float64, Float64} = (0.025, 0.975)) where F
    loci_names = Symbol.(loci(data))
    sample_pairs = pairwise_pairs(sample_names)
    n_samples = length(samples(data))
    n_per_loci = DataFrames.combine(groupby(data.loci, :locus), :genotype => nonmissing => :n)[:, :n]
    allele_frequencies = allele_freq(data)
    relate_vecs = map(i -> Vector{Union{Missing,Float64}}(undef, length(sample_pairs)), 1:length(method))
    boot_means, boot_medians, boot_ses = map(i -> deepcopy(relate_vecs), 1:3)
    boot_CI = map(i -> Vector{Union{Missing,Tuple{Float64,Float64}}}(undef, length(sample_pairs)), 1:length(method))
    shared_loci = Vector{Int}(undef, length(sample_pairs))
    p = Progress(length(sample_pairs), dt = 1, color = :blue)
    popdata_idx = groupby(data.loci, :name)
    idx = 0
    @inbounds for (sample_n, ind1) in enumerate(sample_names[1:end-1])
        geno1 = popdata_idx[(ind1,)].genotype
        @inbounds @sync Base.Threads.@spawn for ind2 in sample_names[sample_n+1:end]
            idx += 1

            geno2 = popdata_idx[(ind2,)].genotype

            # filter out loci missing in at least one individual in the pair
            loc,gen1,gen2, n_per_loc = collect.(skipmissings(loci_names, geno1, geno2, n_per_loci))

            # populate shared_loci array
            @inbounds shared_loci[idx] = length(loc)
            @inbounds for (i, mthd) in enumerate(method)
                @inbounds relate_vecs[i][idx] = mthd(gen1, gen2, loc, allele_frequencies, loc_n = n_per_loc, n_samples = n_samples)
                boot_out = bootstrap_locus(data, mthd, ind1, ind2, iterations, allele_frequencies)
                @inbounds boot_means[i][idx], boot_medians[i][idx], boot_ses[i][idx], boot_CI[i][idx] = bootstrap_summary(boot_out, iterations, interval)
            end
            update!(p, idx)
        end
    end
    method_colnames = [Symbol("$i") for i in method]
    boot_mean_colnames = [Symbol("$i"*"_mean") for i in method]
    boot_median_colnames = [Symbol("$i"*"_median") for i in method]
    boot_se_colnames = [Symbol("$i"*"_SE") for i in method]
    CI_percent = convert(Int64, round(interval[2] - interval[1], digits = 2) * 100)
    boot_CI_colnames = [Symbol("$i"*"_CI_"*"$CI_percent") for i in method]

    out_df = DataFrame(:sample_1 => map(i -> i[1], sample_pairs), :sample_2 => map(i -> i[2], sample_pairs), :n_loci => shared_loci)
    @inbounds for (i, mth) in enumerate(method_colnames)
        out_df[:, mth] = relate_vecs[i]
        out_df[:, boot_mean_colnames[i]] = boot_means[i]
        out_df[:, boot_median_colnames[i]] = boot_medians[i]
        out_df[:, boot_se_colnames[i]] = boot_ses[i]
        out_df[:, boot_CI_colnames[i]] = boot_CI[i]
    end

    return out_df
end

function relatedness_no_boot(data::PopData; method::F) where F
    sample_names = samples(data) |> collect
    relatedness_no_boot(data, sample_names, method = method)
end

function relatedness_bootstrap(data::PopData; method::F, iterations::Int = 100, interval::Tuple{Float64, Float64} = (0.025, 0.975)) where F
    sample_names = samples(data) |> collect
    relatedness_bootstrap(data, sample_names, method = method, iterations = iterations, interval = interval)
end

"""
    relatedness(data::PopData; method::Function, iterations::Int64, interval::Tuple{Float64, Float64})
    relatedness(data::PopData; method::Vector{Function}, iterations::Int64, interval::Tuple{Float64, Float64})

Return a dataframe of pairwise relatedness estimates for all individuals in a `PopData` object.
To calculate means, median, standard error, and confidence intervals using bootstrapping,
set `iterations = n` where `n` is an integer greater than `0` (the default) corresponding to the number
of bootstrap iterations you wish to perform for each pair. The default confidence interval is `(0.05, 0.95)` (i.e. 90%), however that can be changed by supplying a `Tuple{Float64, Float64}` of `(low, high)` to the keyword `interval`.
**Note:** samples must be diploid.
### methods
There are several estimators available and are listed below. `relatedness` takes the
function names as arguments (**case sensitive**), therefore do not use quotes or colons
in specifying the methods. Methods can be supplied as a vector.

**Tip** since the methods correspond to function names, they will tab-autocomplete when
inputting them. For more information on a specific method, please see the respective docstring (e.g. `?Loiselle`).
- `QuellerGoodnight`
- `Ritland`
- `Lynch`
- `LynchRitland`
- `LynchLi`
- `Loiselle`
- `LiHorvitz`
- `Blouin`
- `Moran`
- `Wang`

**Examples**
```juila
julia> cats = nancycats();

julia> relatedness(cats, method = Ritland);

julia> relatedness(cats, method = [Ritland, Wang]);

julia> relatedness(cats, method = [Loiselle, Moran], iterations = 100);

julia> relatedness(cats, method = [Loiselle, Moran], iterations = 100, interval = (0.5, 0.95));
```
"""
function relatedness(data::PopData; method::F, iterations::Int64 = 0, interval::Tuple{Float64, Float64} = (0.025, 0.975)) where F
    sample_names = samples(data) |> collect
    relatedness(data, sample_names, method = method, iterations = iterations, interval = interval)
end


"""
    relatedness(data::PopData, sample_names::Vector{String}; method::Function, iterations::Int64, interval::Tuple{Float64, Float64})
    relatedness(data::PopData, sample_names::Vector{String}; method::Vector{Function}, iterations::Int64, interval::Tuple{Float64, Float64})

Return a dataframe of pairwise relatedness estimates for all pairs of the supplied sample names in a `PopData` object.
To calculate means, median, standard error, and confidence intervals using bootstrapping,
set `iterations = n` where `n` is an integer greater than `0` (the default) corresponding to the number
of bootstrap iterations you wish to perform for each pair. The default confidence interval is `(0.05, 0.95)` (i.e. 90%),
however that can be changed by supplying a `Tuple{Float64, Float64}` of `(low, high)` to the keyword `interval`.
**Note:** samples must be diploid.
### methods
There are several estimators available and are listed below. `relatedness` takes the
function names as arguments (**case sensitive**), therefore do not use quotes or colons
in specifying the methods. Methods can be supplied as a vector.

**Tip:** since the methods correspond to function names, they will tab-autocomplete when
inputting them. For more information on a specific method, please see the respective docstring (e.g. `?Loiselle`).
- `QuellerGoodnight`
- `Ritland`
- `Lynch`
- `LynchRitland`
- `LynchLi`
- `Loiselle`
- `LiHorvitz`
- `Blouin`
- `Moran`
- `Wang`

**Examples**
```
julia> cats = nancycats();

julia> relatedness(cats, ["N7", "N111", "N115"], method = Ritland);

julia> relatedness(cats, ["N7", "N111", "N115"], method = [Ritland, Wang]);

julia> relatedness(cats, ["N7", "N111", "N115"], method = [Loiselle, Moran], iterations = 100);

julia> relatedness(cats, ["N7", "N111", "N115"], method = [Loiselle, Moran], iterations = 100, interval = (0.5, 0.95));
```
"""
function relatedness(data::PopData, sample_names::Vector{String}; method::F, iterations::Int64 = 0, interval::Tuple{Float64, Float64} = (0.025, 0.975)) where F
    all(data.meta[data.meta.name .∈ Ref(sample_names), :ploidy] .== 2) == false && error("Relatedness analyses currently only support diploid samples")
    errs = ""
    all_samples = samples(data)
    if sample_names != all_samples
        for i in sample_names
            if i ∉ all_samples
                errs *= " $i,"
            end
        end
        errs != "" && error("Samples not found in the PopData: " * errs)
    end
    if eltype(method) != Function
        method = [method]
    end
    for i in Symbol.(method)
        if i ∉ [:QuellerGoodnight, :Ritland, :Lynch, :LynchLi, :LynchRitland, :Wang, :Loiselle, :Blouin, :Moran, :LiHorvitz]
            errs *= "$i is not a valid method\n"
        end
    end
    errs != "" && error(errs * "Methods are case-sensitive. Please see the docstring (?relatedness) for additional help.")
    if iterations > 0
        relatedness_bootstrap(data, sample_names, method = method, iterations = iterations, interval = interval)
    else
        relatedness_no_boot(data, sample_names, method = method)
    end
end
