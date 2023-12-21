"""
    set_default_CMTheme!(;makie_config=MakieConfig())

Setting sensible defaults with taking care of `pt_per_unit` in MakieConfig.

When saving png, there is a difference in size between the produced figure 
in print and display on a monitor and its dpi settings.
This routine adjusts several seetings given in inch by deviding `makie_config.pt_per_unit`.
"""
function set_default_CMTheme! end

"""
    draw_with_legend!(fig, plt; fig_pos_legend = fig[1,2], kwargs...)

Draw aog plot into Makie figure, `fig[1,1]`, and legend into subfigure.
"""
function draw_with_legend! end

