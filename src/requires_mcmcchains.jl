@info "TwPrototypes: loading MCMCChains utils"
using .MCMCChains # syntax by Requires.jl otherwise warning

"""
Construct a Chains object from array with parmaetes assigned to given section.
The first variant constructs parameter names `secion[1], section[2], ...`.
"""
function Chains_section(a::AbstractArray, section::Symbol)
    varnames = [string(section)*"["*string(i)*"]" for i in 1:size(a,2)]
    Chains_section(a, section, varnames)
end
function Chains_section(a::AbstractArray, section::Symbol, varnames)
    Chains(a, varnames, Dict(section => varnames))
end

"""
    add_vars(fgetvars, chn, section::Symbol, var_ret, var_arg = names(chn,[:parameters]))

Extend Chain `chn` by section consisting of variables var_ret. The variables are
computed by function fgetvars(args), where args is a subset of a single sample in chain.
The subset is taken by extracting variables var_arg.

TODO example, testcase, used in exploreP.add_obs
"""
function add_vars(fgetvars::Function, chn, section::Symbol, var_ret::AbstractArray{Symbol}, var_arg = names(chn,[:parameters]))
    # var_ret = symbol.(var_obs)
    # var_arg = names(chn,[:parameters, :u0])
    #tmp_vars = mapslices(identity, chn[:,index_vars,:].value, dims=(2))
    tmp_vars = mapslices(fgetvars, chn[:,var_arg,:].value, dims=(2))
    chn_obs = Chains(tmp_vars, var_ret, Dict(section => var_ret))
    if chains(chn) != chains(chn_obs)
        chn = Chains(chn.value, names(chn), chn.name_map)
    end
    chn_ext = hcat(chn, chn_obs)
end

"""
    chainscat_resample(chns) 

concatenate chains and resample longer chains, only keep intersection of variables.
Sections are taken from first chain.
"""
function chainscat_resample(chns) 
    # reduce to subset of variables
    par_names = names.(chns)
    par_names_int = reduce(intersect, par_names)
    # also remove variables from sections
    chn1 = first(chns)
    name_map_int = Dict(map(sections(chn1)) do sec
        names_int = intersect( names(chn1, sec), par_names_int)
        sec => names_int
    end)
    #i_chn_morevars = length.(par_names) .> length(par_names_int)
    # chns2 = map(chns, i_chn_morevars) do chn, is_more
    #     is_more ? chn[:,par_names_int,:] : chn
    # end
    chns2 = map(chns) do chn
        #chn[:,par_names_int,:]  # does not reorder columns
        chains_par(chn, par_names_int)
    end
    # reduce to same minimum sample number
    #fsubsample = (chn) -> Chains(chn[rand(1:size(chn,1), n_min),:,:].value, names(chn), chn.name_map)
    fsubsample = (chn) -> Chains(chn[rand(1:size(chn,1), n_min),:,:].value, names(chn), name_map_int)
    n_min, n_max = extrema(map(x -> size(x,1), chns))
    chns3 = map(chns2) do chn
        size(chn,1) == n_min ? resetrange(chn) : fsubsample(chn)
    end
    chn_exti = chainscat(chns3...)
end

"""
    chains_par(chns, par_names)

Construct chain of given parameters of original chain. This helps to 
plot variables that are not in the :parameters section
"""
chains_par(chns, par_names) = Chains(chns[:,par_names,:].value, par_names)
    

"""
Parameters in Turing are put to the :parameters section and are named 
`popt[1], popt[2], ...`. Replace those identifiers
by given names (symbols)
"""
rename_chain_pars(chn, popt_names) = replacenames(
    chn, Dict(MCMCChains.names(chn, :parameters) .=> popt_names))


    """
    construct_chains_from_csv(chn_df; fsections=(vars)->Dict(...))

Reconstruct a MCMCChains object from DataFrame, `chn_df`, as produced by `CSV.write`, 
i.e. with columns
`iteration`,`chain`, `parameters`+, `internals`+.

function `fsections(vars)` must return a Dictionary passed to `MCMCChains.set_section`.
The default assumes that starting from symbol :lp all variables belong to section internals,
and all variables before to the standard section parameters.
"""
function construct_chains_from_csv(chn_df; 
    fsections=(vars)->Dict(:internals=>vars[findfirst(==(:lp), vars):end])
    )
    as = map(pairs(groupby(chn_df, :chain))) do (i, subdf)
        Array(select(subdf, Not(1:2)))
    end
    a = reduce((x, y) -> cat(x, y; dims = 3), as)
    MCMCChains.Chains(a, names(chn_df)[3:end], fsections(propertynames(chn_df)[3:end]))
end

