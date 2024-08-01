using Test
using TwPrototypes

@testset "parse_backup_path" begin
    #slc = (site = :LUE, targetlim = :lim_P, scenario = (:prior_sep,))
    project = "SesamFitSPP"
    data_category = "posterior-sample"
    experiment = "somescenario" 
    backup_dir = mktempdir()
    try
        path = get_backup_path(;project, data_category, experiment, backup_dir)
        res = parse_backup_path(path)
        @test res.backup_dir == backup_dir
        @test res.project == project
        @test res.data_category == data_category
        @test res.experiment == experiment
        @test res.version == "1"
        @test res.extension == "csv"
    finally
        rm(backup_dir, recursive=true, force=true)
    end
end;

