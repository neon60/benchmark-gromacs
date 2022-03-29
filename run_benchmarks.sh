#!/bin/bash


_CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"


function usage(){
  echo \
"""
Usage:
run_benchmarks.sh [[OPTIONS]]

General Options
---------------
[-o|--out-dir <dir>] Path to output directory
[-t|--type <mpi, tmpi, tmpi_stream, tmpi_init>] Specify to run mpi or threaded mpi
)
"""
}


parse_arguments(){
  set +u
  while (( "$#" )); do
    case "$1" in
      -o|--out-dir)
        out_dir="$2"
        shift 2
        ;;
      -t|--type)
        run_type="$2"
        shift 2
        ;;
      --) # end argument parsing
        shift
        break
        ;;
      -*|--*=|*) # unsupported flags
        echo "Error: Unsupported flag $1" >&2
        usage
        exit 1
        ;;
    esac
  done

  if [[ -z "${run_type+x}" ]]; then
      echo "Must specify run-type -t as either 'mpi', 'tmpi', 'tmpi_stream' or 'tmpi_init'"
      exit -1
  fi

  if [[ -z "${out_dir+x}" ]]; then
      out_dir="/tmp"
      echo "using /tmp as output directory"
  fi
}


parse_arguments $*

run_mpi(){
    echo "running mpi mode"

    cd $_CWD
    ./gromacs_mpi.sh $out_dir
}


run_tmpi(){
    echo "running threaded mpi mode"

    cd $_CWD
    ./gromacs_tmpi.sh $out_dir
}

run_tmpi_stream(){
    echo "running threaded mpi mode"

    cd $_CWD
    ./gromacs_tmpi_stream.sh $out_dir
}

run_tmpi_init(){
    echo "running threaded mpi mode"

    cd $_CWD
    ./gromacs_tmpi_init.sh $out_dir
}
export GMX_ENABLE_DIRECT_GPU_COMM=1
export GMX_FORCE_UPDATE_DEFAULT_GPU=1
export ROC_ACTIVE_WAIT_TIMEOUT=0
export AMD_DIRECT_DISPATCH=70

if [[ $run_type == "mpi" ]]; then
     run_mpi
fi

if [[ $run_type == "tmpi" ]]; then
    run_tmpi
fi

if [[ $run_type == "tmpi_stream" ]]; then
    run_tmpi_stream
fi

if [[ $run_type == "tmpi_init" ]]; then
    run_tmpi_init
fi
