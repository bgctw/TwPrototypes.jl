module TwPrototypesCairoMakieExt

function __init__()
    @info "TwPrototypes: loading CairoMakie utils"
end

isdefined(Base, :get_extension) ? (using CairoMakie) : (using ..CairoMakie)
import TwPrototypes as CM
using TwPrototypes


function CM.pdf_figure_axis(args...; makie_config::MakieConfig = MakieConfig(), kwargs...) 
    fig = pdf_figure(args...; makie_config)
    fig, Axis(fig[1,1]; kwargs...)
end

function CM.pdf_figure(; makie_config::MakieConfig = MakieConfig())
    (;pt_per_unit, fontsize, size_inches) = makie_config
    resolution = 72 .* size_inches ./ pt_per_unit # size_pt
    fig = Figure(;resolution, fontsize = fontsize./ pt_per_unit)
end
function CM.pdf_figure(size_inches::NTuple{2}; makie_config::MakieConfig = MakieConfig())
    makie_config = MakieConfig(makie_config; size_inches)
    pdf_figure(;makie_config)
end
function CM.pdf_figure(width2height::Number; makie_config::MakieConfig = MakieConfig())
    size_inches = (makie_config.size_inches[1], makie_config.size_inches[1]/width2height)
    makie_config = MakieConfig(makie_config; size_inches)
    pdf_figure(;makie_config)
end

function CM.save_with_config(filename::AbstractString, fig::Union{Figure, Makie.FigureAxisPlot, Scene}; makie_config = MakieConfig(), args...)
    local cfg = makie_config
    pathname, ext = splitext(filename) 
    ext != "" && @warn "replacing extension $ext by $(cfg.filetype)"
    bname = basename(pathname) * "." *  cfg.filetype
    dir = joinpath(dirname(pathname), string(cfg.target))
    filename_cfg = joinpath(dir,bname)
    mkpath(dir)
    #save(filename_cfg, fig, args...)
    save(filename_cfg, fig, args...; pt_per_unit = makie_config.pt_per_unit)
    filename_cfg
end

CM.hidexdecoration!(ax; label = false, ticklabels = false, ticks = false, grid = false, minorgrid = false, minorticks = false, kwargs...) = hidexdecorations!(ax; label, ticklabels, ticks, grid, minorgrid, minorticks, kwargs...)

CM.hideydecoration!(ax; label = false, ticklabels = false, ticks = false, grid = false, minorgrid = false, minorticks = false, kwargs...) = hideydecorations!(ax; label, ticklabels, ticks, grid, minorgrid, minorticks, kwargs...)

CM.axis_contents(axis::Axis) = axis
CM.axis_contents(figpos::GridLayout) = axis_contents(first(contents(figpos)))
CM.axis_contents(figpos::GridPosition) = axis_contents(first(contents(figpos)))


# plot density from MCMCChains.value
function CM.density_params(chns, pars=names(chns, :parameters); 
    makie_config::MakieConfig=MakieConfig(), 
    fig = pdf_figure(cm2inch.((8.3,8.3/1.618)); makie_config), 
    column = 1, xlims=nothing, 
    labels=nothing, colors = nothing, ylabels = nothing, normalize = false, 
    kwargs_axis = repeat([()],length(pars)), kwargs...
    )
    n_chains = size(chns,3)
    n_samples = length(chns)
    labels_ch = isnothing(labels) ? string.(1:n_chains) : string.(labels)
    ylabels = isnothing(ylabels) ? string.(pars) : ylabels
    !isnothing(xlims) && (length(xlims) != length(pars)) && error(
        "Expected length(xlims)=$(length(xlims)) (each a Tuple or nothing) to be length(pars)=$(length(pars))")
    for (i, param) in enumerate(pars)
        ax = Axis(fig[i, column]; ylabel=ylabels[i], kwargs_axis[i]...)
        if isnothing(colors)
            colors = ax.palette.color[]
        end
        for i_chain in 1:n_chains
            _values = chns[:, param, i_chain]
            col = colors[i_chain]
            if normalize
                k = KernelDensity.kde(_values)
                md = maximum(k.density)
                lines!(ax, k.x, k.density ./ md; label=labels_ch[i_chain], color = col, kwargs...)
            else
                density!(ax, _values; label=labels_ch[i_chain], color = (col, 0.3), strokecolor = col, strokewidth = 1, 
                #strokearound = true,
                kwargs...)
            end
        end
        xlim = passnothing(getindex)(xlims, i)
        !isnothing(xlim) && xlims!(ax, xlim)
    #hideydecorations!(ax,  ticklabels=false, ticks=false, grid=false)
        hideydecorations!(ax, label=false, ticklabels=true)
        # if i < length(params)
        #     hidexdecorations!(ax; grid=false)
        # else
        #     ax.xlabel = "Parameter estimate"
        # end
    end
    # axes = [only(contents(fig[i, 2])) for i in 1:length(params)]
    # linkxaxes!(axes...)
    #axislegend(only(contents(fig[2, column])))
    fig    
end


end