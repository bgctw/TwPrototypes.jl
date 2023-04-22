tmp_f = function()
    push!(LOAD_PATH, "/User/homes/twutz/twutz/julia/makietools")
    push!(LOAD_PATH, "/User/homes/twutz/twutz/julia/turingtools")
    push!(LOAD_PATH, "/User/homes/twutz/twutz/julia/18_tools/makietools")
    push!(LOAD_PATH, "/User/homes/twutz/twutz/julia/18_tools/turingtools")
end
using CairoMakie
using AlgebraOfGraphics

@testset "pdf_figure with constants" begin
    makie_config = ppt_MakieConfig()
    makie_config = ppt_MakieConfig(filetype="pdf")
    #makie_config.size_inches ./ cm2inch(1)
    cfg2 = MakieConfig(makie_config, fontsize = 20)
    @test cfg2.fontsize == 20
    #
    @test all(isapprox.(cm2inch(6,7,9), (2.36, 2.75, 3.54); atol = 0.02))
    #
    # changing the size by first argument
    fig = pdf_figure(cm2inch(8,8); makie_config = MakieConfig(paper_MakieConfig(), pt_per_unit = 0.75,))
    @test size(fig.scene) == (302, 302) # regression test, but numbers must be equal
    #
    makie_config = MakieConfig(filetype="png", target=:presentation)
    set_default_CMTheme!(;makie_config)
    fig,ax = pdf_figure_axis(golden_ratio;makie_config); 
    data = cumsum(randn(4, 101), dims = 2)
    series!(ax, data, labels=["label $i" for i in 1:4])
    ax.xlabel = "xlabel"; ax.ylabel = "ylabel"
    axislegend(ax)
    #display(fig)
    #save_with_config("tmp/test", fig; makie_config)
    #
    tmpdir = mktempdir()
    try
        fname = save_with_config(joinpath(tmpdir,"testfig"), fig; makie_config)
        @test fname == joinpath(tmpdir,"presentation","testfig.png")
    finally
        rm(tmpdir, recursive=true)
    end
    #
end;

i_test_larger_margins = () -> begin
    makie_config = ppt_MakieConfig(filetype="png")
    set_default_CMTheme!(;makie_config)
    fig,ax = pdf_figure_axis(;makie_config); 
    data = cumsum(randn(4, 101), dims = 2)
    series!(ax, data, labels=["label $i" for i in 1:4])
    axislegend(ax)
    display(fig)
    passmissing(cumsum)
end

@testset "density_params" begin
    using AxisArrays: AxisArrays
    a = reshape(randn(40*3*2), (40,3,2));
    chn = AxisArrays.AxisArray(a; row=1:size(a,1), parameters=string.('a':'c'));
    #plt = density_params(chn, AxisArrays.axes(chn,2));
    plt = density_params(chn, ["a","b"]);
    #display(plt)
     @test plt isa CairoMakie.Figure
end;

