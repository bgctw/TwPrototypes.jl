using Test
using TwPrototypes 

@testset "non-required" begin
    include("test_isofeltype.jl")
    include("test_util.jl")
end

@testset "mcmcchains" begin
    #include("test/test_mcmcchains.jl")
    include("test_mcmcchains.jl")
end

@testset "cairomakie" begin
    include("test_cairomakie.jl")
end


