#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2021. All Rights Reserved.
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
set -ex

# Set needed variables for conda build environment
BAZEL_RC_DIR=$1

cat >> $BAZEL_RC_DIR/.bazelrc << EOF
build --action_env GCC_HOST_COMPILER_PATH="${CC}"
build --define=CUB_NS_QUALIFIER="::cub"
build --cxxopt=-DTHRUST_IGNORE_CUB_VERSION_CHECK
build --linkopt="-fuse-ld=gold"
EOF
