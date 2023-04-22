module TwPrototypesAoGExt

function __init__()
    @info "TwPrototypes: loading TwPrototypesAoGExt"
end


isdefined(Base, :get_extension) ? 
    (using CairoMakie,AlgebraOfGraphics) : (using ..CairoMakie,..AlgebraOfGraphics)
import TwPrototypes as CM
using TwPrototypes
    
function CM.set_default_CMTheme!(;makie_config=MakieConfig())
    set_aog_theme!()
    local cfg = makie_config
    legend_theme = Theme(
        Legend=(
            bgcolor=(:white,0.8),
            framevisible=true,
            rowgap=0.2,
            framewidth=0.2,
            framecolor=(:lightgrey,0.8),
            padding=(5.0,5.0,2.0,2.0) ./ cfg.pt_per_unit,
            patchsize=(20.0,10.0) ./ cfg.pt_per_unit,
            margin=(2,2,2,2) ./ cfg.pt_per_unit,
    ))
    update_theme!(legend_theme)
    update_theme!(
        figure_padding = (1,16,1,10) ./ cfg.pt_per_unit, # room for top and right axis label
        Lines = (linewidth = 0.8 / cfg.pt_per_unit,)  ,    
        Series = (linewidth=0.8 / cfg.pt_per_unit,),
        )
    axis_theme = Theme(
        Axis=(
            #xlabelsize=20, 
            xgridvisible=true,
            ygridvisible=true,
            #xgridstyle=:dash, ygridstyle=:dash,
            xtickalign=1.0, ytickalign=1.0, 
            yticksize=3 / cfg.pt_per_unit, xticksize=3 / cfg.pt_per_unit,
            xticklabelpad=0,
            xlabelpadding=0,
            #ylabelpadding=0,
            #leftspinevisible = false,
            rightspinevisible = true,
            # bottomspinevisible = false,
            topspinevisible = true,        
            topspinecolor = :darkgray,
            rightspinecolor = :darkgray,
        )    
    )    
    update_theme!(axis_theme)
end

"""
Draw aog plot into Makie figure and legend into subfigue
"""
function CM.draw_with_legend!(fig, plt; fig_pos_legend = fig[1,2], kwargs...)
    local _legend = draw!(fig[1,1], plt)
    legend!(fig_pos_legend, _legend)
    _legend
end

end # module

