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
# A collection of PyPlot wrappers  #
####################################

##################################
# INFO:                                                  
# Most polar plots in week 0                
# are quite custom,only used once       
# hence                                                   
# an object-oriented approach                
# was not taken.                                       
# Instead, one function                            
# to generate each plot.                            
##################################

# plot of a single state vector 
function single_state_vector_plot()
    fig = figure(figsize=(4,4))
    r = [0,1]
    @manipulate for θ=-180:15:180;  
        θ_rad = 2*pi*θ/360
        digits = 3
        α = round(cosd(θ),digits)
        β = round(sind(θ),digits)
        withfig(fig) do        
            ax = axes(polar = "true")
            ax[:set_ylim]([0,1.1])
            ax[:set_yticks]([0,1,1.1])
            ax[:set_yticklabels](["","","\$ <\\psi|\\psi> =1 \$"])
            ax[:set_xticklabels](["\$|0\\rangle\$","\$|+\\rangle\$",
                                              "\$|1\\rangle\$","\$-|-\\rangle\$",
                                              "\$-|0\\rangle\$","\$-|+\\rangle\$",
                                              "\$-|1\\rangle\$","\$|-\\rangle\$"])
                        
            plot(θ_rad*ones(2),r,color="#ee8d18", label = "\$ |\\psi(\\theta)\\rangle \$");
            scatter(θ_rad,1,s=50, c="red", alpha=0.5);
            title("\$|\\psi(\\theta)\\rangle =\$ $α \$|0\\rangle\$ + $β \$|1\\rangle\$",y=1.12)
            legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)   
        end
    end
end

# plot of a measurement basis, a state vector and the resulting projections/probabilities
function measurement_plot()
    fig = figure(figsize=(4,4))
    @manipulate for θ = -180:15:180, γ = -180:15:180;
        
        θ_rad = 2*pi*θ/360
        γ_rad = 2*pi*γ/360
        dot = round(abs(cosd(θ - γ)),3)
        digits = 3
        P_x = round(dot^2,digits)
        
        withfig(fig) do        
            ax = axes(polar = "true")
            ax[:set_ylim]([0,1.1])
            ax[:set_xticklabels](["\$|0\\rangle\$","\$|+\\rangle\$",
                                              "\$|1\\rangle\$","\$-|-\\rangle\$",
                                              "\$-|0\\rangle\$","\$-|+\\rangle\$",
                                              "\$-|1\\rangle\$","\$|-\\rangle\$"])
            ax[:set_yticks]([0,1])
            ax[:set_yticklabels](["",""])
            plot(θ_rad*ones(2), 
                    [0,1], 
                    color="#ee8d18", 
                    label="\$|\\psi(\\theta)\\rangle\$");
            scatter(θ_rad, 
                        1,
                        s=50, 
                        c="red", 
                        alpha=0.5);            
            
            plot(γ_rad*ones(2), 
                    [0,1], 
                    linestyle=":", 
                    color="blue");
            plot(γ_rad*ones(2), 
                    dot*[0,1], 
                    color="blue", 
                    label="\$|b(\\gamma)\\rangle\$");
            scatter(γ_rad,
                        1, 
                        s = 50, 
                        c = "blue", 
                        alpha = 0.5);

            title("\$ P\_{B=0} = |\\langle b_0 | \\psi \\rangle|^2 \$ = $(P_x)",
                     y =1.12)
            legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)               
        end
    end
end

# single state vector and its unitary transform.
function unitary_transform_plot(U)

    fig = figure(figsize=(4,4))
    r = [0,1]
    @manipulate for θ=-180:15:180
        θ_rad  = 2*pi*θ/360
        
        ket = [cos(θ_rad ),sin(θ_rad )]
        ketT = U*ket
        θ_radT = sign(ketT[2])*acos(ketT[1])

        withfig(fig) do        
            ax = axes(polar = "true")
            ax[:set_ylim]([0,1.1])
            ax[:set_yticks]([0,1])
            ax[:set_yticklabels](["",""])
            ax[:set_xticklabels](["\$|0\\rangle\$","\$|+\\rangle\$",
                                              "\$|1\\rangle\$","\$-|-\\rangle\$",
                                              "\$-|0\\rangle\$","\$-|+\\rangle\$",
                                              "\$-|1\\rangle\$","\$|-\\rangle\$"])
                        
            plot(θ_rad*[1,1],
                    [0,1],
                    color = "#ee8d18",
                    label = "\$|\\psi(\\theta)\\rangle\$");
            scatter(θ_rad, 
                        1,
                        s = 50, 
                        c = "red", 
                        alpha = 0.5);
            
                plot(θ_radT*[1,1],
                        [0,1],
                        color = "blue",
                        label = "\$U⋅|\\psi(\\theta)\\rangle\$");
                scatter(θ_radT, 
                            1,
                            s = 50, 
                            c = "blue", 
                            alpha = 0.5);
                   
            title("", y =1.12)
            legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)        
        end
    end
end

# projective measurement of a single state
function projective_measurement_plot()
    fig = figure(figsize=(4,4))
    vDict = Dict("0" => 0, "+" => 45,"-" => -45) # options for the state to be measured
    @manipulate for state in ["0","+","-"]

        θ_rad = 2*pi*vDict[state]/360
        b_0_rad = acos(sqrt(1/3))
        b_1_rad = b_0_rad - pi/2
        inner_0 = cos(θ_rad - b_0_rad)
        inner_1 = cos(θ_rad - b_1_rad)
        p_0 = round(inner_0^2,3)
        p_1 = round(inner_1^2,3)

        # Due to https://github.com/matplotlib/matplotlib/issues/2133,
        # ensure that all polar radii are positive.
        b_0_pos_rad = b_0_rad + (inner_0 < 0 ? (inner_0 *= -1; pi) : 0)
        b_1_pos_rad = b_1_rad + (inner_1 < 0 ? (inner_1 *= -1; pi) : 0)
        
        withfig(fig) do        
            ax = axes(polar = "true")
            ax[:set_ylim]([0,1.1])
            ax[:set_xticklabels](["\$|0\\rangle\$","\$|+\\rangle\$",
                                              "\$|1\\rangle\$","\$-|-\\rangle\$",
                                              "\$-|0\\rangle\$","\$-|+\\rangle\$",
                                              "\$-|1\\rangle\$","\$|-\\rangle\$"])
            ax[:set_yticks]([0,1])
            ax[:set_yticklabels](["",""])
            plot(θ_rad*ones(2), 
                    [0,1], 
                    color="#ee8d18", 
                    label="\$|\\psi\\rangle\$");
            scatter(θ_rad, 
                        1,
                        s=50, 
                        c="red", 
                        alpha=0.5);            
            plot(b_0_rad*ones(2), 
                    [0,1], 
                    linestyle=":", 
                    color="blue");
            plot(b_0_pos_rad*ones(2), 
                    inner_0*[0,1], 
                    color="blue", 
                    label="\$|b_0\\rangle\$");
            scatter(b_0_rad,
                        1, 
                        s = 50, 
                        c = "blue", 
                        alpha = 0.5);

            plot(b_1_rad*ones(2), 
                    [0,1], 
                    linestyle=":", 
                        color="green");
            plot(b_1_pos_rad*ones(2), 
                    inner_1*[0,1], 
                        color="green", 
                    label="\$|b_1\\rangle\$");
            scatter(b_1_rad,
                        1, 
                        s = 50, 
                        c = "green", 
                        alpha = 0.5);

            title("\$ p\_0 = |\\langle b_0 | \\psi \\rangle|^2 \$ = $(p_0), \$ p\_1 = |\\langle b_1 | \\psi \\rangle|^2 \$ = $(p_1)",
                     y =1.12)
            legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)           
        end
    end
end


# plot 2D vector representing 1 qubit and its "hadamard image".
function pi8_rotated_basis_plot()
    fig = figure(figsize=(4,4))
    r = [0,1]
    ax = axes(polar = "true")
    ax[:set_ylim]([0,1.1])
    ax[:set_yticks]([0,1])
    ax[:set_yticklabels](["",""])
    ax[:set_xticklabels](["\$|0\\rangle\$","\$|+\\rangle\$",
                                      "\$|1\\rangle\$","\$-|-\\rangle\$",
                                      "\$-|0\\rangle\$","\$-|+\\rangle\$",
                                      "\$-|1\\rangle\$","\$|-\\rangle\$"])
    plot(0*[1,1],
            [0,1],
            color = "red",
            label = "\$|0\\rangle\$,\$|1\\rangle\$ ");
    scatter(0, 
                1,
                s = 50, 
                c = "red");
    plot(0.5*pi*[1,1],
            [0,1],
            color = "red");
    scatter(0.5*pi, 
                1,
                s = 50, 
                c = "red");    
    plot(0.125*pi*[1,1],
            [0,1],
            color = "blue",
            label = "\$|0_L\\rangle\$,\$|1_L\\rangle\$ ");
    scatter(0.125*pi, 
                1,
                s = 50, 
                c = "blue");
    plot(0.625*pi*[1,1],
            [0,1],
            color = "blue");
    scatter(0.625*pi, 
                1,
                s = 50, 
                c = "blue", 
                alpha = 0.5);
    title("", y =1.12)
    legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)           
end
