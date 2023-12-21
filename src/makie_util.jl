using Parameters: @with_kw
import KernelDensity

cm_per_inch = 2.54

"""
    cm2inch(x)
    cm2inch(x1, x2, x...)

Convert length in cm to inch units: 1 inch = 2.54  
The single argument returns a value, the multiple argument version a Tuple.
Similar to more verbose syntax using Unitful.jl: `uconvert(u"inch",x * u"cm").val`.
"""
cm2inch(x) = x/cm_per_inch
#cm2inch(x1, x2, args...) = (cm2inch(x) for x in (x1,x2,args...))
cm2inch(x1, x2, args...) = Tuple(cm2inch(x) for x in (x1,x2,args...))


"""
    golden_ratio ≈ 1.618

Two quantities are in the golden ratio if their ratio is the same as 
the ratio of their sum to the larger of the two quantities.
"""
const golden_ratio = 1.618

"""
    MakieConfig

A collection of figure properties to tailor the same figure either
for presentation in a paper or a presentation.

    ppt_MakieConfig(;
        target = :presentation, 
        filetype = "png", 
        fontsize=18, 
        size_inches = (5.0,5.0/golden_ratio), 
        kwargs...) 

    paper_MakieConfig(;
        size_inches = cm2inch.((8.3,8.3/golden_ratio)), 
        kwargs...) 

Properties and defaults
- `pt_per_unit = 0.75`
- `filetype = "png"`
- `fontsize = 9`   (point units)
- `size_inches = cm2inch.((17.5,17.5/golden_ratio))` (witdth x height)
"""            
@with_kw struct MakieConfig{FT,IT} 
    target::Symbol            = :paper
    pt_per_unit::FT           = 0.75   
    filetype::String          = "png"
    fontsize::IT              = 9
    size_inches::Tuple{FT,FT} = cm2inch.((17.5,17.5/golden_ratio))
end


#ppt_MakieConfig(;target = :presentation, pt_per_unit = 0.75/2, filetype = "png", fontsize=18, size_inches = cm2inch.((29,29/golden_ratio)), kwargs...) = MakieConfig(;target, pt_per_unit, filetype, fontsize, size_inches, kwargs...)
# size so that orginal size covers half a wide landscape slide of 33cm
# svg does not work properly with fonts in ppt/wps
#ppt_MakieConfig(;target = :presentation, filetype = "png", fontsize=18, size_inches = cm2inch.((16,16/golden_ratio)), kwargs...) = MakieConfig(;target, filetype, fontsize, size_inches, kwargs...)
# target of 10inch wide screen slide
ppt_MakieConfig(;target = :presentation, filetype = "png", fontsize=18, size_inches = (5.0,5.0/golden_ratio), kwargs...) = MakieConfig(;target, filetype, fontsize, size_inches, kwargs...)

paper_MakieConfig(;size_inches = cm2inch.((8.3,8.3/golden_ratio)), kwargs...) = MakieConfig(;size_inches, kwargs...)


"""
    pdf_figure = (size_inches = cm2inch.((8.3,8.3/golden_ratio)); fontsize=9, pt_per_unit = 0.75)
    pdf_figure_axis = (size_inches = cm2inch.((8.3,8.3/golden_ratio)); fontsize=9, pt_per_unit = 0.75, kwargs...)

Creates a figure with specified resolution and fontsize 
for given figure size. 
`pdf_figure_axis`, in addition returns an Makie.Axis created with kwargs.
They uses by default `pt_per_unit=0.75` to conform to png display and save. Remember to devide fontsize and other sizes specified elsewhere by this factor.
See also [`cm2inch`](@ref) and `save`.
"""    
function pdf_figure end;
function pdf_figure_axis end;    

"""
    save_with_config(filename, fig; makie_config = MakieConfig(), args...)

Save figure with file updated extension `cfg.filetype` to subdirectory `cfg.filetype`
of given path of filename.
Set `pt_per_unit` to `makie_config.pt_per_unit`.
"""
function save_with_config end   

"""
    hidexdecoration!(ax;, label, ticklabels, ticks, grid, minorgrid, minorticks; kwargs...)
    hideydecoration!(ax;, label, ticklabels, ticks, grid, minorgrid, minorticks; kwargs...)

Versions of hidexdecorations! and hideydecorations! with defaults reversed.
This allows to selectively hide single decorations, e.g. only the label.
"""
function hidexdecoration! end,
function hideydecoration! end

"""
Extract axis object from given figure position. Works recursively until an 
Axis-object is returned
"""
function axis_contents end

"""
    density_params(chns, pars=names(chns, :parameters); 
        makie_config::MakieConfig=MakieConfig(), 
        fig = pdf_figure(cm2inch.((8.3,8.3/1.618)); makie_config), 
        column = 1, xlims=nothing, 
        labels=nothing, colors = nothing, ylabels = nothing, normalize = false, 
        kwargs_axis = repeat([()],length(pars)), 
        prange = (0.025, 0.975), # do not extend x-scale to outliers
        kwargs...
    )

Plot density from MCMCChains.value with facets for each parameter.
"""
function density_params end


