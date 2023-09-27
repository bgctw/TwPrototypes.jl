@testset "BasicSrunBuilder" begin
    builder = BasicSrunBuilder()
    cmd = @inferred build_srun_command(builder, 4)
    #
    builder = BasicSrunBuilder(;mem_GB=10,time_hours=4)
    cmd = @inferred build_srun_command(builder, 4)
    @test occursin(r"\s--mem=10GB\b", cmd)
    @test occursin(r"\s--time=4:00:00\b", cmd)
    @test occursin(r"\s--cpus-per-task=4\b", cmd)
    #
    builder = BasicSrunBuilder(;partition="single")
    cmd = @inferred build_srun_command(builder, 1)
    @test occursin(r"\s-p single\b", cmd)
end;

