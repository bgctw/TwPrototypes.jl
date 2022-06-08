using Test
using TwPrototypes
using SimpleTraits

# @traitfn not working inside @testset


@testset "isofeltype" begin
    
@testset "dummy" begin
    @test istrait(IsOfEltype{Int64}) 
    @test !istrait(IsOfEltype{Float64})
end;

end; # isofeltype

