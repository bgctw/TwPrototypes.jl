export get_backup_path, parse_backup_path

"""
    get_backup_path(;
        backup_dir="output", date = Dates.Date(Dates.now()), version = "1", extension="csv", 
        project, data_category, experiment)

Create a expressive filepath to store output of experiments.

## Arguments
- project: project identifier
- data_category: kind of data in the project
- version: version of the dataset
- experiment: further informatin such as scenario, treatment, parameters, etc
- extension: file extension 

project, data_category, and version must not contain an underscore, '_' to be
parsed again by [`parse_backup_path`](@ref).
"""
function get_backup_path(;
    #date = Dates.Date(Dates.now()),
    version = "1", extension="csv", backup_dir=DrWatson.projectdir("outputs"),
    project, data_category, experiment)
    #data_category="posterior-sample"
    path = joinpath(
        backup_dir,
        #"$(date)_$(project)_$(data_category)_v$(version)_$(experiment).$(extension)")
        "$(project)_$(data_category)_v$(version)_$(experiment).$(extension)")
end

"""
    parse_backup_path(path)

Extract the components from path created by [`get_backup_path`](@ref) as a NamedTuple.
"""
function parse_backup_path(path)
    fname = basename(path)
    #m = match(r"([^_]+)_([^_]+)_([^_]+)_v([^_]+)_(.+)\.(.+)$", fname)
    m = match(r"([^_]+)_([^_]+)_v([^_]+)_(.+)\.(.+)$", fname)
    isnothing(m) && error("expected format " * 
        r"$(project)_v$(version)_$(data_category)_$(experiment).$(extension)" * 
        " but got $fname"
        )
    (;backup_dir=dirname(path), project=m.captures[1], data_category=m.captures[2], 
    version=m.captures[3], experiment=m.captures[4], extension = m.captures[5])
end

