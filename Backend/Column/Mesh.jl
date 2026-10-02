using Gmsh
function create_I_section(
    B,
    D,
    tf,
    tw,
    h
)
    x_left = 0.0
    x_right = B
    x_web_left =(B - tw) / 2
    x_web_right =(B + tw) / 2
    z_bottom = 0.0
    z_bottom_flange =tf
    z_top_flange =D - tf
    z_top =D

    p1 = gmsh.model.geo.addPoint(x_left,0,z_bottom,h)

    p2 = gmsh.model.geo.addPoint(x_right,0,z_bottom,h)

    p3 = gmsh.model.geo.addPoint(x_right,0,z_bottom_flange,h)

    p4 = gmsh.model.geo.addPoint(x_web_right,0,z_bottom_flange,h)

    p5 = gmsh.model.geo.addPoint(x_web_right,0,z_top_flange,h)

    p6 = gmsh.model.geo.addPoint(x_right,0,z_top_flange,h)

    p7 = gmsh.model.geo.addPoint(x_right,0,z_top,h)

    p8 = gmsh.model.geo.addPoint(x_left,0,z_top,h)

    p9 = gmsh.model.geo.addPoint(
        x_left,
        0,
        z_top_flange,
        h
    )

    p10 = gmsh.model.geo.addPoint(
        x_web_left,
        0,
        z_top_flange,
        h
    )

    p11 = gmsh.model.geo.addPoint(
        x_web_left,
        0,
        z_bottom_flange,
        h
    )

    p12 = gmsh.model.geo.addPoint(
        x_left,
        0,
        z_bottom_flange,
        h
    )


    # --------------------------------------------------------
    # Lines
    # --------------------------------------------------------

    l1 = gmsh.model.geo.addLine(
        p1,
        p2
    )

    l2 = gmsh.model.geo.addLine(
        p2,
        p3
    )

    l3 = gmsh.model.geo.addLine(
        p3,
        p4
    )

    l4 = gmsh.model.geo.addLine(
        p4,
        p5
    )

    l5 = gmsh.model.geo.addLine(
        p5,
        p6
    )

    l6 = gmsh.model.geo.addLine(
        p6,
        p7
    )

    l7 = gmsh.model.geo.addLine(
        p7,
        p8
    )

    l8 = gmsh.model.geo.addLine(
        p8,
        p9
    )

    l9 = gmsh.model.geo.addLine(
        p9,
        p10
    )

    l10 = gmsh.model.geo.addLine(
        p10,
        p11
    )

    l11 = gmsh.model.geo.addLine(
        p11,
        p12
    )

    l12 = gmsh.model.geo.addLine(
        p12,
        p1
    )


    # --------------------------------------------------------
    # Curve loop
    # --------------------------------------------------------

    curve_loop =
        gmsh.model.geo.addCurveLoop([
            l1,
            l2,
            l3,
            l4,
            l5,
            l6,
            l7,
            l8,
            l9,
            l10,
            l11,
            l12
        ])


    # --------------------------------------------------------
    # Surface
    # --------------------------------------------------------

    surface =
        gmsh.model.geo.addPlaneSurface([
            curve_loop
        ])


    return surface

end


# ============================================================
# CREATE C / CHANNEL SECTION
# ============================================================

function create_C_section(
    B,
    D,
    tf,
    tw,
    h
)

    # --------------------------------------------------------
    # Channel profile
    # --------------------------------------------------------

    p1 = gmsh.model.geo.addPoint(
        0,
        0,
        0,
        h
    )

    p2 = gmsh.model.geo.addPoint(
        B,
        0,
        0,
        h
    )

    p3 = gmsh.model.geo.addPoint(
        B,
        0,
        tf,
        h
    )

    p4 = gmsh.model.geo.addPoint(
        tw,
        0,
        tf,
        h
    )

    p5 = gmsh.model.geo.addPoint(
        tw,
        0,
        D - tf,
        h
    )

    p6 = gmsh.model.geo.addPoint(
        B,
        0,
        D - tf,
        h
    )

    p7 = gmsh.model.geo.addPoint(
        B,
        0,
        D,
        h
    )

    p8 = gmsh.model.geo.addPoint(
        0,
        0,
        D,
        h
    )


    # --------------------------------------------------------
    # Lines
    # --------------------------------------------------------

    l1 = gmsh.model.geo.addLine(
        p1,
        p2
    )

    l2 = gmsh.model.geo.addLine(
        p2,
        p3
    )

    l3 = gmsh.model.geo.addLine(
        p3,
        p4
    )

    l4 = gmsh.model.geo.addLine(
        p4,
        p5
    )

    l5 = gmsh.model.geo.addLine(
        p5,
        p6
    )

    l6 = gmsh.model.geo.addLine(
        p6,
        p7
    )

    l7 = gmsh.model.geo.addLine(
        p7,
        p8
    )

    l8 = gmsh.model.geo.addLine(
        p8,
        p1
    )


    # --------------------------------------------------------
    # Curve loop
    # --------------------------------------------------------

    curve_loop =
        gmsh.model.geo.addCurveLoop([
            l1,
            l2,
            l3,
            l4,
            l5,
            l6,
            l7,
            l8
        ])


    # --------------------------------------------------------
    # Surface
    # --------------------------------------------------------

    surface =
        gmsh.model.geo.addPlaneSurface([
            curve_loop
        ])


    return surface

end


# ============================================================
# MAIN COLUMN MESH GENERATOR
# ============================================================

function create_column_mesh(
    result;
    output_file = "Column.msh",
    stl_file = "Column.stl"
)

    # --------------------------------------------------------
    # Extract section type
    # --------------------------------------------------------

    section_type =
        String(
            result["Section_Type"]
        )


    # --------------------------------------------------------
    # Extract dimensions
    #
    # Logic_Column:
    #   dimensions -> mm
    #
    # Gmsh:
    #   dimensions -> m
    # --------------------------------------------------------

    D =
        Float64(
            result["Depth_mm"]
        ) / 1000.0

    B =
        Float64(
            result["Width_mm"]
        ) / 1000.0

    tf =
        Float64(
            result["tf_mm"]
        ) / 1000.0

    tw =
        Float64(
            result["tw_mm"]
        ) / 1000.0

    L =
        Float64(
            result["Length_m"]
        )


    # --------------------------------------------------------
    # Validation
    # --------------------------------------------------------

    if D <= 0

        return Dict(
            "error" =>
                "Section depth must be greater than zero."
        )

    end


    if B <= 0

        return Dict(
            "error" =>
                "Section width must be greater than zero."
        )

    end


    if tf <= 0

        return Dict(
            "error" =>
                "Flange thickness must be greater than zero."
        )

    end


    if tw <= 0

        return Dict(
            "error" =>
                "Web thickness must be greater than zero."
        )

    end


    if L <= 0

        return Dict(
            "error" =>
                "Column length must be greater than zero."
        )

    end


    # --------------------------------------------------------
    # Mesh size
    # --------------------------------------------------------

    h = min(
        0.25,
        min(B, D) / 3
    )

    h = max(
        h,
        0.01
    )


    # --------------------------------------------------------
    # Initialize Gmsh
    # --------------------------------------------------------

    gmsh.initialize()

    try

        gmsh.model.add(
            "Column"
        )


        # ----------------------------------------------------
        # Create section profile
        # ----------------------------------------------------

        if section_type == "I"

            surface =
                create_I_section(
                    B,
                    D,
                    tf,
                    tw,
                    h
                )

        elseif section_type == "C"

            surface =
                create_C_section(
                    B,
                    D,
                    tf,
                    tw,
                    h
                )

        else

            error(
                "Unsupported section type: $section_type"
            )

        end


        # ----------------------------------------------------
        # Synchronize 2D geometry
        # ----------------------------------------------------

        gmsh.model.geo.synchronize()


        # ----------------------------------------------------
        # Extrude section along Y
        # ----------------------------------------------------

        gmsh.model.geo.extrude(
            [(2, surface)],
            0,
            L,
            0,
            [20],
            [1.0],
            true
        )


        # ----------------------------------------------------
        # Synchronize 3D geometry
        # ----------------------------------------------------

        gmsh.model.geo.synchronize()


        # ----------------------------------------------------
        # Mesh settings
        # ----------------------------------------------------

        gmsh.option.setNumber(
            "Mesh.CharacteristicLengthMin",
            h
        )

        gmsh.option.setNumber(
            "Mesh.CharacteristicLengthMax",
            h
        )

        gmsh.option.setNumber(
            "Mesh.Algorithm3D",
            1
        )


        # ----------------------------------------------------
        # Generate 3D mesh
        # ----------------------------------------------------

        gmsh.model.mesh.generate(
            3
        )


        # ----------------------------------------------------
        # Save Gmsh mesh
        # ----------------------------------------------------

        gmsh.write(
            output_file
        )


        # ----------------------------------------------------
        # Save STL surface mesh
        # ----------------------------------------------------

        gmsh.write(
            stl_file
        )


    finally

        gmsh.finalize()

    end


    # --------------------------------------------------------
    # Return information
    # --------------------------------------------------------

    return Dict(

        "success" =>
            true,

        "mesh_file" =>
            output_file,

        "stl_file" =>
            stl_file,

        "mesh_url" =>
            "/design/column/mesh",

        "stl_url" =>
            "/design/column/stl",

        "section_type" =>
            section_type,

        "length_m" =>
            L,

        "depth_m" =>
            D,

        "width_m" =>
            B,

        "tf_m" =>
            tf,

        "tw_m" =>
            tw
    )

end