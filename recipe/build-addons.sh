#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2020, 2022. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************
set -vex

source open-ce-common-utils.sh

if [[ $build_type == "cuda" ]];
then 
  export TF_NEED_CUDA=1
  export TF_CUDA_VERSION="${cudatoolkit%.*}"
  export TF_CUDNN_VERSION="${cudnn%.*}"
  export CUDA_TOOLKIT_PATH=$CUDA_HOME,$PREFIX,"/usr/include"
  export CUDNN_INSTALL_PATH=$PREFIX
  export TF_CUDA_COMPUTE_CAPABILITIES=${cuda_levels}
fi
python ./configure.py

SCRIPT_DIR=$RECIPE_DIR/../buildscripts
$SCRIPT_DIR/set_python_path_for_bazelrc.sh $SRC_DIR
$SCRIPT_DIR/set_tf_addons_for_bazelrc.sh $SRC_DIR

bazel build --enable_runfiles build_pip_pkg

# build a whl file
mkdir -p $SRC_DIR/tensorflow_addons_pkg
bazel-bin/build_pip_pkg $SRC_DIR/tensorflow_addons_pkg

ls -l $SRC_DIR/tensorflow_addons_pkg

# install using pip from the whl file
pip install --no-deps $SRC_DIR/tensorflow_addons_pkg/*.whl

echo "PREFIX: $PREFIX"
echo "RECIPE_DIR: $RECIPE_DIR"

PID=$(bazel info server_pid)
echo "PID: $PID"
cleanup_bazel $PID
