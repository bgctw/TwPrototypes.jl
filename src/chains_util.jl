# define and document functions that are implemented in MCMCChainsExt

"""
Construct a Chains object from array with parmaetes assigned to given section.
The first variant constructs parameter names `secion[1], section[2], ...`.
"""
function Chains_section end

"""
    add_vars(fgetvars, chn, section::Symbol, var_ret, var_arg = names(chn,[:parameters]))

Extend Chain `chn` by section consisting of variables var_ret. The variables are
computed by function fgetvars(args), where args is a subset of a single sample in chain.
The subset is taken by extracting variables var_arg.
Note, that the fgetvars receives an AxisArray where the order of parameters does
not necessarily correspond to var_arg
TODO example, testcase, used in exploreP.add_obs
"""
function add_vars end

"""
    chainscat_resample(chns) 

concatenate chains and resample longer chains, only keep intersection of variables.
Sections are taken from first chain.
"""
function chainscat_resample end

"""
    chains_par(chns, par_names)

Construct chain of given parameters of original chain. This helps to 
plot variables that are not in the :parameters section
"""
function chains_par end

"""
Parameters in Turing are put to the :parameters section and are named 
`popt[1], popt[2], ...`. Replace those identifiers
by given names (symbols)
"""
function rename_chain_pars end

"""
    construct_chains_from_csv(chn_df; fsections=(vars)->Dict(...))

Reconstruct a MCMCChains object from DataFrame, `chn_df`, as produced by `CSV.write`, 
i.e. with columns
`iteration`,`chain`, `parameters`+, `internals`+.

function `fsections(vars)` must return a Dictionary passed to `MCMCChains.set_section`.
The default assumes that starting from symbol :lp all variables belong to section internals,
and all variables before to the standard section parameters.
"""
function construct_chains_from_csv end





