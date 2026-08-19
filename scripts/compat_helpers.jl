
# Add missing compat entries to Project.toml
#
# For each direct dependency, checks if the entry is not existing
# and adds the currently use major version (or minor bevore 1.0) 
# as a compat entry to Project.toml

using Pkg, TOML

function version_spec(v::VersionNumber)
    if v.major == 0
        "0.$(v.minor)"
    else
        string(v.major)
    end
end

tmpf = () -> begin
    Pkg.activate("test")
    Pkg.activate("docs")
end

Pkg.instantiate()
project_file = Pkg.project().path
project = TOML.parsefile(project_file)
existing_compat = get(project, "compat", Dict())

# Look for name in current project, or fall back to parent project
project_name = get(project, "name", nothing)
if project_name === nothing
    parent_project_file = joinpath(dirname(project_file), "..", "Project.toml")
    if isfile(parent_project_file)
        parent_project = TOML.parsefile(parent_project_file)
        project_name = get(parent_project, "name", nothing)
    end
end

for (_, dep) in Pkg.dependencies()
    dep.is_direct_dep || continue
    # if dep.name == "Statistics" 
    #     Main.@infiltrate_main
    # end
    dep.name == project_name && continue  # skip the main package
    spec = version_spec(dep.version)
    
    if !haskey(existing_compat, dep.name)
        Pkg.compat(dep.name, spec)
    else
        existing_spec = Pkg.Versions.semver_spec(existing_compat[dep.name])
        if !in(dep.version, existing_spec)
            new_compat = existing_compat[dep.name] * ", " * spec
            Pkg.compat(dep.name, new_compat)
        end
    end
end

