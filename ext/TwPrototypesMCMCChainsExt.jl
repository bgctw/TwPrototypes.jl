module TwPrototypesMCMCChainsExt

function __init__()
    @info "TwPrototypes: loading TwPrototypesMCMCChainsExt"
end

isdefined(Base, :get_extension) ? (using MCMCChains) : (using ..MCMCChains)
import TwPrototypes as CM
using TwPrototypes
using DataFrames
using Infiltrator

function CM.Chains_section(a::AbstractArray, section::Symbol)
    varnames = [string(section)*"["*string(i)*"]" for i in 1:size(a,2)]
    Chains_section(a, section, varnames)
end
function CM.Chains_section(a::AbstractArray, section::Symbol, varnames)
    Chains(a, varnames, Dict(section => varnames))
end

function CM.add_vars(fgetvars::Function, chn, section::Symbol, 
    var_ret::AbstractArray{Symbol}, var_arg = names(chn,[:parameters]))
    # var_ret = symbol.(var_obs)
    # var_arg = names(chn,[:parameters, :u0])
    #tmp_vars = mapslices(identity, chn[:,index_vars,:].value, dims=(2))
    tmp_vars = mapslices(fgetvars, chn[:,var_arg,:].value, dims=(2))
    chn_obs = Chains(tmp_vars, var_ret, Dict(section => var_ret))
    if chains(chn) != chains(chn_obs)
        chn = Chains(chn.value, names(chn), chn.name_map)
    end
    names_double=intersect(names(chn), names(chn_obs))
    if length(names_double)!=0
        error("Adding variables ot a chain requires uniqe names. " *
        "Found following nonunique names: " * join(names_double,", "))
    end
    # @show intersect(names(chn), names(chn_obs))
    # @infiltrate
    chn_ext = hcat(chn, chn_obs)
end

function CM.chainscat_resample(chns) 
    # reduce to shared subset of variables
    par_names = names.(chns)
    par_names_int = reduce(intersect, par_names)
    # also remove variables from sections
    chn1 = first(chns)
    name_map_int = map(sections(chn1)) do sec
        names_int = intersect( names(chn1, sec), par_names_int)
        sec => names_int
    end
    #i_chn_morevars = length.(par_names) .> length(par_names_int)
    # chns2 = map(chns, i_chn_morevars) do chn, is_more
    #     is_more ? chn[:,par_names_int,:] : chn
    # end
    chns2 = map(chns) do chn
        #chn[:,par_names_int,:]  # does not reorder columns
        #chains_par(chn, par_names_int) # does not preserve name_map
        chains_par(chn, par_names_int; name_map = name_map_int) 
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


#does not preserve order in par_names
#CM.chains_par(chns, par_names) = set_section(chns[:,par_names,:], Dict(:parameters => par_names))
# indexing into chns or chns.value also does not preserve order of par_names
#CM.chains_par(chns, par_names) = Chains(chns[:,par_names,:].value, par_names)
# need to extract each variable separately and bind_col afterwards
function CM.chains_par(chns, par_names; name_map=(parameters = par_names,)) 
    Chains(hcat(map(x -> chns.value[:,[x],:], par_names)...), par_names, name_map)
end

CM.rename_chain_pars(chn, popt_names) = replacenames(
    chn, Dict(MCMCChains.names(chn, :parameters) .=> popt_names))

function CM.construct_chains_from_csv(chn_df; 
    fsections=(vars)->Dict(:internals=>vars[findfirst(==(:lp), vars):end])
    )
    as = map(pairs(groupby(chn_df, :chain))) do (i, subdf)
        Array(select(subdf, Not(1:2)))
    end
    a = reduce((x, y) -> cat(x, y; dims = 3), as)
    MCMCChains.Chains(a, names(chn_df)[3:end], fsections(propertynames(chn_df)[3:end]))
end




end # module

