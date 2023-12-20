"""
  slurm_execute(julia_snippet, njobs=1, nthreads=1;
    srun_builder = BasicSrunBuilder(),
    cmd_julia = "julia -t \$nthreads --project --startup-file=no",
    shell = "/bin/sh",
    is_verbose = false,
    )

Schedule the execution of the snippet of julia code `njobs` times 
at the cluster, and wait for all jobs to finish.

The code snipped may determine the job-id by
`index = get(ENV, "SLURM_ARRAY_TASK_ID", 0)`
"""
function slurm_execute(julia_snippet, njobs=1, nthreads=1;
  srun_builder = BasicSrunBuilder(),
  # the mljulia bash script calls  'module load julia' before invokingn julia
  cmd_julia = "mljulia -t $nthreads --project --startup-file=no",
  shell = "/bin/sh",
  is_verbose = false,
  )
  cmd_srun = build_srun_command(srun_builder, nthreads)
  script_tmp = 
"""  
  for N in {1..$njobs};
    do
        export SLURM_ARRAY_TASK_ID=\$N
        #$cmd_srun $cmd_julia code/main_showargs.jl &
        $cmd_srun $cmd_julia -e '$julia_snippet' &
    done
  wait
  exit_code=\$?
  echo Finished jobs with exit code \$exit_code
  exit \$exit_code
"""
  cmd = `$shell -c "$script_tmp"`
  if is_verbose; @show cmd; end
  ans = run(cmd)
end

tmpf = () -> begin
  script_julia = 
"""
index = get(ENV, "SLURM_ARRAY_TASK_ID", 0)
println("Started index = \$index")
sleep(1.0)
println("Finished index = \$index")
"""
  ans = slurm_execute(script_julia,3);
  ans = slurm_execute(script_julia,3; srun_builder=LocalSrunBuilder(), is_verbose=true);
end


abstract type AbstractSrunBuilder; end

struct LocalSrunBuilder <: AbstractSrunBuilder; end
build_srun_command(srb::LocalSrunBuilder, nthreads) = ""

struct BasicSrunBuilder{IT} <: AbstractSrunBuilder
  mem_GB::IT
  time_hours::IT
  partition::String15
end

"""
  BasicSrunBuilder(;mem_GB=20,time_hours=48)

`build_srun_command(BasicSrunBuilder(), nthreads)` will compile a string for an slurm
srun-command with specified 

- mem_GB: memory limit (integer GB)
- time_hours: maximum execution time (integer hours)
- nthreads: cpus-per-task
"""
BasicSrunBuilder(;mem_GB=20,time_hours=48, partition="") = BasicSrunBuilder(mem_GB,time_hours,String15(partition))

function build_srun_command(builder::BasicSrunBuilder, nthreads)
  partitionstr = isempty(builder.partition) ? "" : "-p " * builder.partition * " " 
  "srun " * partitionstr * "--mem=$(builder.mem_GB)GB --time=$(builder.time_hours):00:00 --cpus-per-task=$nthreads"
end
