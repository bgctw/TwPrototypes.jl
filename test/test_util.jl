@testset "passnothing" begin
    sum_splice(args...) = sum(args)
    fn = passnothing(sum_splice)
    @test fn(1,3,2) == sum_splice(1,3,2)
    @test isnothing(fn(1,3,nothing))
end;

i_test_ComponentArrays = () -> begin
    anames = (:a, :b, :c)
    cv = ComponentVector(collect(eachindex(anames)), Axis(anames))
    cv[KeepIndex(:a)]
    cv[(:a,:b)] # works since 0.12.0
end

