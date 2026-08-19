
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

for (_, dep) in Pkg.dependencies()
    dep.is_direct_dep || continue
    spec = version_spec(dep.version)
    
    if !haskey(existing_compat, dep.name)
        Pkg.compat(dep.name, spec)
    else
        existing_spec = Pkg.Version.semver_spec(existing_compat[dep.name])
        if !in(dep.version, existing_spec)
            new_compat = existing_compat[dep.name] * ", " * spec
            Pkg.compat(dep.name, new_compat)
        end
    end
end

