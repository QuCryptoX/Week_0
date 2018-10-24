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

#############################################
# INFO:
# This is supposed to be a port of
# QuTiPs Bloch Sphere (open source; just matplotlib)
#############################################

##############################################
# Summary:
#               Allows you to make Bloch sphere pictures
#               in an object-oriented fashion.
#               Basically, user creates an instance of type Bloch
#               add elements to be plotted with add_vector(), etc.
#               render the picture with render() function.
#               Should be easy to follow. See below.

#####################
# TYPE DEFINITION
#####################

# ELEMENT type: elements to plot on the Bloch sphere:
# Points, vectors, lines etc.
mutable struct Element
    coord::Vector
    kind::AbstractString
    label::AbstractString
    linestyle::AbstractString
    markerSize::Number
end

# BLOCH Sphere type:
# a collection of information
# which can be used to render
# a Bloch Sphere picture
# using the render() function.
mutable struct Bloch
    sphere_color::Vector{Float64}
    mesh_color::Vector{Float64}
    axis_color::Vector{Float64}
    equator_color::Vector{Float64}
    view_elevation::Float64
    view_azimuth::Float64
    elements::Vector{Element} # our points/vectors
    colors::Vector{String}
end

# Standard Initialization
Bloch() = Bloch([0.5,0.1,0.1,0.02],
                            [0,0,0,0.05],
                            [0,0,0,0.3],
                            [0,0,0,0.3],
                            20,
                            30,
                            [],
                            ["r","g","b","c","y","m"]
                            )

#############
# METHODS
#############

# method to add element to BS
function add_element(b::Bloch,
                                        coord::Vector;
                                        kind = "vector",
                                        label ="",
                                        linestyle = "-",
                                        markerSize = 20)

    if length(coord) == 2 # assume degree coords θ,ϕ
        xyz = [
                sind(coord[1])*cosd(coord[2]),
                sind(coord[1])*sind(coord[2]),
                cosd(coord[1])
                ]
    elseif length(coord) == 3 # assume cartesian
        xyz = coord
    else
        error("Points = [θ,ϕ] (degrees) or [x,y,z] (float)")
    end

    for el in b.elements
        if el.coord == xyz
            return
        end
    end

    push!(b.elements,Element(xyz,kind,label,linestyle,markerSize))
end

# Some Aliassing
add_vector(b::Bloch, coord::Vector) = add_element(b::Bloch, coord::Vector)

# "Clear the plot"
function clear(b::Bloch)
    b.elements = []
end

    ########################################################
    # Render the Bloch sphere: sphere, mesh, equator, axis
    ########################################################
function render(b::Bloch,rotate_z = 0)

    n = 48
    u = linspace(0,2*π,n);
    v = linspace(0,π,n);

    x = cos(u) * sin(v)';
    y = sin(u) * sin(v)';
    z = ones(n) * cos(v)';

    # Sphere surface
    surf(x,y,z, rstride=1, cstride=1, color=b.sphere_color, linewidth=0, shade=true)

    # Sphere mesh
    mesh(x,y,z, rstride=10, cstride=6, color=b.mesh_color)

    # plot equator
    plot( cos(u), sin(u), zs=0, color=b.equator_color, linewidth= 1 )
    plot( cos(u), sin(u), zs=0, zdir="x", color=b.equator_color, linewidth= 1 )

    # plot xyz bloch sphere axis
    span = linspace(-1,1,2)
    plot(span, 0*span, zs=0, color=b.axis_color, linewidth=1, label="X")
    plot(0*span, span, zs=0, color=b.axis_color, linewidth=1, label="Y")
    plot(0*span, span, zs=0, zdir="y", color=b.axis_color, linewidth=1, label="Z")

    ######################
    # Plot elements on BS
    ######################
    if length(b.elements)>0
        for (i,el) in enumerate(b.elements)

            if el.kind == "point"
                scatter3D(
                            el.coord[1],
                            el.coord[2],
                            el.coord[3],
                            s = el.markerSize,
                            color = b.colors[(i-1)%6 + 1]
                            )

            elseif el.kind == "vector"
                plot(
                        [0,1]*el.coord[1],
                        [0,1]*el.coord[2],
                        [0,1]*el.coord[3],
                        linestyle = el.linestyle,
                        color = b.colors[(i-1)%6 + 1]
                )
                scatter3D(
                            el.coord[1],
                            el.coord[2],
                            el.coord[3],
                            s = el.markerSize,
                            color = b.colors[(i-1)%6 + 1]
                            )
            else
                error("Add vectors or points.")
            end
        end
    end

    ###########
    # Styling
    ###########
   # get the current axes(drawing area)
    ax = gca()

     # put bloch axis labels
    ax[:text](0, 1.3, 0, "\$y\$")
    ax[:text](1.3, 0, 0, "\$x\$")
    ax[:text](0, 0, 1.2, "\$z\$")

     # remove the grid on the axis panels.
    ax[:grid](false)

    # remove axis ticks/labels
    for a in vcat(ax[:w_xaxis][:get_ticklines](),ax[:w_xaxis][:get_ticklabels]())
        a[:set_visible](false)
    end
    for a in vcat(ax[:w_yaxis][:get_ticklines](),ax[:w_yaxis][:get_ticklabels]())
        a[:set_visible](false)
    end
    for a in vcat(ax[:w_zaxis][:get_ticklines](),ax[:w_zaxis][:get_ticklabels]())
        a[:set_visible](false)
    end

    # remove backpanels
    ax[:w_xaxis][:pane][:set_visible](false)
    ax[:w_yaxis][:pane][:set_visible](false)

    # remove  z-axis
    ax[:w_zaxis][:line][:set_visible](false)

    # make sphere look like a sphere
    ax[:set_aspect](true)

    # view angle
    ax[:view_init](b.view_elevation,b.view_azimuth+rotate_z)
end
