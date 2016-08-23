# Copyright (c) 2016, QuTech, TU Delft, written by W. Hekman and S. Wehner
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
# 
# 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 

####################################
# Recurring general purpose functions      
####################################

###############
# CONVERSION 
###############

# Summary: can be used to transform a qubit state vector into its Bloch coordinate vector
# Input: two (complex) numbers,
# Output: cartesian Bloch coordinate vector.
function ket_to_bloch(ket::Vector, digits = 3)
    α = ket[1]
    β = ket[2]
    v_x = α*conj(β) + conj(α)*β  # = 2Re(α*conj(β))
    v_y = im*α*conj(β) - im*conj(α)*β # = -2Re(α*conj(β))
    v_z = α*conj(α) - β*conj(β)
    return round(real([v_x,v_y,v_z]),digits)
end

function ket_to_bloch(α::Number,β::Number, digits = 3)
    v_x = α*conj(β) + conj(α)*β  # = 2Re(α*conj(β))
    v_y = im*α*conj(β) - im*conj(α)*β # = -2Re(α*conj(β))
    v_z = α*conj(α) - β*conj(β)
    return round(real([v_x,v_y,v_z]),digits)
end

