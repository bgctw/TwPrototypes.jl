using Test
using TwPrototypes
import SimpleTraits as ST

# @traitfn not working inside @testset


@testset "isofeltype" begin
    
@testset "dummy" begin
    @test ST.istrait(IsOfEltype{Int64}) 
    @test !ST.istrait(IsOfEltype{Float64})
end;

end; # isofeltype

