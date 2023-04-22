using Parameters: @with_kw
import KernelDensity

"""
    cm2inch(x)
    cm2inch(x1, x2, x...)

Convert length in cm to inch units: 1 inch = 2.54  
The single argument returns a value, the multiple argument version a Tuple.
"""
cm2inch(x) = x/2.54
#cm2inch(x1, x2, args...) = (cm2inch(x) for x in (x1,x2,args...))
cm2inch(x1, x2, args...) = Tuple(cm2inch(x) for x in (x1,x2,args...))

const golden_ratio = 1.618

@with_kw struct MakieConfig{FT,IT} 
    target::Symbol            = :paper
    pt_per_unit::FT           = 0.75   
    filetype::String          = "png"
    fontsize::IT              = 9
    size_inches::Tuple{FT,FT} = cm2inch.((17.5,17.5/golden_ratio))
end


#ppt_MakieConfig(;target = :presentation, pt_per_unit = 0.75/2, filetype = "png", fontsize=18, size_inches = cm2inch.((29,29/golden_ratio)), kwargs...) = MakieConfig(;target, pt_per_unit, filetype, fontsize, size_inches, kwargs...)
ppt_MakieConfig(;target = :presentation, filetype = "png", fontsize=18, size_inches = cm2inch.((16,16/golden_ratio)), kwargs...) = MakieConfig(;target, filetype, fontsize, size_inches, kwargs...)
# size so that orginal size covers half a wide landscape slide of 33cm
# svg does not work properly with fonts in ppt/wps

paper_MakieConfig(size_inches = cm2inch.((8.3,8.3/golden_ratio)), kwargs...) = MakieConfig(;size_inches, kwargs...)


"""
    pdf_figure = (size_inches = cm2inch.((8.3,8.3/golden_ratio)); fontsize=9,pt_per_unit = 0.75)
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

Save figure with file extension `cfg.filetype` to subdirectory `cfg.filetype`
of given path of filename
"""
function save_with_config end   

"""
    hidexdecoration!(ax;, label, ticklabels, ticks, grid, minorgrid, minorticks; kwargs...)
    hideydecoration!(ax;, label, ticklabels, ticks, grid, minorgrid, minorticks; kwargs...)

Versions of hidexdecorations! and hideydecorations! with defaults reversed.
This allows to selectively hide single decorations, e.g. only the label.
"""
function hidexdecoration! end
function hideydecoration! end

"""
Extract axis object from given figure position. Works recursively until an 
Axis-object is returned
"""
function axis_contents end

function density_params end


