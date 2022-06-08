"""
Concepts in Julia that have not found its proper package.
"""
module TwPrototypes

export 
    IsOfEltype

export 
    makeddocs    

export cm2inch, golden_ratio, MakieConfig, ppt_MakieConfig, paper_MakieConfig,
    pdf_figure_axis, pdf_figure, save_with_config,
    hidexdecoration!, hideydecoration!, axis_contents, density_params

export set_default_CMTheme!, draw_with_legend!

export passnothing, named_componentvector

export Chains_section, add_vars, chainscat_resample, chains_par, rename_chain_pars


using SimpleTraits    
import Pkg
using Requires: @require 
import ComponentArrays as CA

function __init__()
    @require CairoMakie = "13f3f980-e62b-5c42-98c6-ff1f3baf88f0" begin
        include("requires_cairomakie.jl")
        @require AlgebraOfGraphics = "cbdf2221-f076-402e-a563-3d30da359d67" begin
            include("requires_algebraofgraphics.jl")
        end
    end
    @require MCMCChains = "c7f686f2-ff18-58e9-bc7b-31028e88f75d" begin
        include("requires_mcmcchains.jl")
    end
end

include("isofeltype.jl")
include("pkg_utils.jl")
include("util.jl")



    
end # module
