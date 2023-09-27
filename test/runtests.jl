tmp_f = function()
    pop!(LOAD_PATH)
    push!(LOAD_PATH, expanduser("~/twutz/julia/18_tools/devtools"))
end

using Test
using TwPrototypes 
import DataFrames
import CSV

@testset "util_slurm" begin
    include("test_util_slurm.jl")
end

@testset "non-required" begin
    #TODO resolve SimpleTraits issue https://github.com/mauro3/SimpleTraits.jl/issues/83
    include("test_isofeltype.jl")
    include("test_util.jl")
    include("test_data_management.jl")
end

@testset "mcmcchains" begin
    #include("test/test_mcmcchains.jl")
    include("test_mcmcchains.jl")
end

@testset "cairomakie" begin
    include("test_cairomakie.jl")
end


