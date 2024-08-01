using Test, SafeTestsets
const GROUP = get(ENV, "GROUP", "All") # defined in in CI.yml
@show GROUP

@time begin
    if GROUP == "All" || GROUP == "Basic"
        #join_path(test_path, ...) does not work, because test_path is unknown in new module
        #@safetestset "Tests" include("test/test_util_slurm.jl")
        @time @safetestset "test_util_slurm" include("test_util_slurm.jl")
        #@safetestset "Tests" include("test/test_isofeltype.jl")
        @time @safetestset "test_isofeltype" include("test_isofeltype.jl")
        #@safetestset "Tests" include("test/test_util.jl")
        @time @safetestset "test_util" include("test_util.jl")
        #@safetestset "Tests" include("test/test_data_management.jl")
        @time @safetestset "test_data_management" include("test_data_management.jl")
    end

    if GROUP == "All" || GROUP == "MCMCChains"
        #join_path(test_path, ...) does not work, because test_path is unknown in new module
        #@safetestset "Tests" include("test/test_mcmcchains.jl")
        @time @safetestset "test_mcmcchains" include("test_mcmcchains.jl")
    end

    if GROUP == "All" || GROUP == "CairoMakie"
        #join_path(test_path, ...) does not work, because test_path is unknown in new module
        #@safetestset "Tests" include("test/test_cairomakie.jl")
        @time @safetestset "test_cairomakie" include("test_cairomakie.jl")
    end

    # if GROUP == "All" || GROUP == "JET"
    #     #@safetestset "Tests" include("test/test_JET.jl")
    #     @time @safetestset "test_JET" include("test_JET.jl")
    #     #@safetestset "Tests" include("test/test_aqua.jl")
    #     @time @safetestset "test_Aqua" include("test_aqua.jl")
    # end
end

# @testset "non-required" begin
#     #TODO resolve SimpleTraits issue https://github.com/mauro3/SimpleTraits.jl/issues/83
#     include("test_isofeltype.jl")
#     include("test_util.jl")
#     include("test_data_management.jl")
# end



