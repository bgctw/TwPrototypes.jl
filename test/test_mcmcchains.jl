i_loadlibs = () -> begin
    # may load from test environment from interactive or user-wide repos
    push!(LOAD_PATH, expanduser("~/twutz/julia/scimltools/")) # access local package repo
    push!(LOAD_PATH, expanduser("~/twutz/julia/turingtools/")) # access local package repo
    #
    push!(LOAD_PATH, expanduser("~/twutz/julia/18_tools/scimltools/")) # access local package repo
    push!(LOAD_PATH, expanduser("~/twutz/julia/18_tools/turingtools/")) # access local package repo
end
using MCMCChains

chn1 = Chains(rand(100, 4, 2), [:a, :b, :c, :d]);
chn1s = set_section(chn1, Dict(:parameters => [:a,:b], :internals => [:c, :d]));

@testset "Chains_section" begin
    u0 = randn(100, 4, 2);
    chn = Chains_section(u0, :u0)
    @test size(chn) == (100,4,2)
    @test names(chn, :u0) == [Symbol("u0[1]"),Symbol("u0[2]"),Symbol("u0[3]"),Symbol("u0[4]")]
end;

@testset "add_vars" begin
    f1 = (v) -> [minimum(v), length(v)]
    names_newvars = [:min_ab, :length_ab]
    chn = add_vars(f1, chn1s, :add, names_newvars);
    @test names(chn, :add) == [:min_ab, :length_ab]
    @test all(chn.value[:,:length_ab,:] .== 2)
end;

@testset "chainscat_resample" begin
    # different number of samles, parameters, and chains
    # different sections (copy from chn1, but merge with chn1s)
    chn2 = chn1[3:100, 1:3, 1]
    #chn2 = chn1s[3:100, 1:3, 1]
    chn = chainscat_resample([chn1s, chn2])
    @test convert(Array,chn.value[:,:,[3]]) == convert(Array,chn2.value)
    @test chn.name_map == (parameters = [:a, :b], internals = [:c])
end;

@testset "chains_par" begin
    chn = chains_par(chn1s, [:b,:c])
    @test convert(Array,chn.value) == convert(Array,chn1s.value[:,[:b,:c],:])
    @test chn.name_map == (parameters = [:b, :c],)
end;

@testset "rename_chain_pars" begin
    chn = rename_chain_pars(chn1s, [:a1,:b1])
    @test chn.name_map == (parameters = [:a1, :b1], internals = [:c, :d])
end;

@testset "backup_restore to CSV" begin
    chn = MCMCChains.Chains(rand(500,4,2), [:a0,:lp, :u10, :u20], Dict(:internals=>[:lp,:u10, :u20]))
    #path,  io = mktemp()
    mktemp() do path, io
        CSV.write(path, chn)
        chn2 = construct_chains_from_csv(CSV.read(path, DataFrames.DataFrame))
        @test chn2.value == chn.value
        @test names(chn2, :internals) == names(chn, :internals)
    end
end;




