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

########################################################################
# Type and functions that allow you to plot 2D polar plots of qubit states.#
#######################################################################


######################################
#                       TYPE DEFINITION              #
######################################

# our 2D Polar composite type
type Polar
    title::AbstractString
    angles::Vector{Float64}
    labels::Vector{AbstractString}
    colors 
end

# Standard Initialization
Polar() = Polar("",
                            [],
                            [],
                            ([1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,0,1],[0,1,1]),
                            )
Polar(title::AbstractString) = Polar(title,
                                                        [],
                                                        [],
                                                        ([1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,0,1],[0,1,1]),
                                                        )
Polar(angle::Float64,label::AbstractString) = Polar("",
                            [angle],
                            [label],
                            ([1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,0,1],[0,1,1]),
                            )

Polar(angle::Int64,label::AbstractString) = Polar("",
                            [2*pi*angle/360],
                            [label],
                            ([1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,0,1],[0,1,1]),
                            )

####################################
#                     METHODS:                          #
####################################

##############
# Utility           #
##############

# "Clear the plot"
function clear(pp::Polar)
    pp.angles = []
    pp.labels = []
end

# set the title
function set_title(pp::Polar, title::AbstractString)
    pp.title = title
end

################
# Adding Vectors #
################

# the radian version
function add_vector(pp::Polar, angle::Float64, label::AbstractString)
    for old in pp.angles
        if angle == old
            info("You added a vector that is already there.")
        end
    end
    push!(pp.labels, label)
    push!(pp.angles, angle)
end 

# the whole degrees version
function add_vector(pp::Polar, angle::Int64, label::AbstractString)
    angle = 2*pi*angle/360
    for old in pp.angles
        if angle == old
            info("You add a vector that is already there.")
        end
    end
    push!(pp.labels, label)
    push!(pp.angles, angle)
end 



############################
# Render the Polar Plot               #
############################
function render(pp::Polar)

    ax = axes(polar = "true")
    #######################
    # Vectors on Polar Plot     #
    #######################
    if length(pp.angles)>0
    for (i,angle) in enumerate(pp.angles)
        plot(
                [1,1]*angle,
                [0,1],
                color = pp.colors[i],
                label = pp.labels[i]
        )
        scatter(
                    [1,1]*angle,
                    [0,1],
                    color = pp.colors[i])
    end
end
       # get the current axes(drawing area)
    title(pp.title, y =1.12)
    legend(loc=6)    
    
    ax[:set_ylim]([0,1.1])
    ax[:set_yticks]([0,1])
    ax[:set_yticklabels](["",""])
    ax[:set_xticklabels](["\$|0\\rangle\$","\$|+\\rangle\$",
                                      "\$|1\\rangle\$","\$-|-\\rangle\$",
                                      "\$-|0\\rangle\$","\$-|+\\rangle\$",
                                      "\$-|1\\rangle\$","\$|-\\rangle\$"])
end
