"""
Concepts in Julia that have not found its proper package.
"""
module TwPrototypes

export 
    IsOfEltype

export 
    makeddocs    

export set_default_CMTheme!, draw_with_legend!

export passnothing, named_componentvector

using SimpleTraits: SimpleTraits, Trait, istrait, @traitdef, @traitimpl, @traitfn  
using DataFrames
import Pkg
import ComponentArrays as CA
import CSV
using InlineStrings

include("isofeltype.jl")
include("pkg_utils.jl")
include("util.jl")
include("data_management.jl")

include("makie_util.jl")
export cm_per_inch, cm2inch, golden_ratio, MakieConfig
export pdf_figure, pdf_figure_axis, save_with_config, ppt_MakieConfig, paper_MakieConfig
export hidexdecoration!, hideydecoration!, axis_contents, density_params, histogram_params

include("aog_util.jl")
export set_default_CMTheme!, draw_with_legend!

include("chains_util.jl")
export Chains_section, add_vars, chainscat_resample, chains_par, rename_chain_pars
export construct_chains_from_csv

export slurm_execute
export AbstractSrunBuilder, LocalSrunBuilder, BasicSrunBuilder, build_srun_command
include("util_slurm.jl")

export downgrade_project
include("version_util.jl")


   
end # module
