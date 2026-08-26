using Oxygen
using HTTP
using JSON3
using CSV
using DataFrames

include("./Column/Logic_Column.jl")
include("./Column/Logic_Column.jl")

function cors_handler(handler)

    return function(req::HTTP.Request)

        # Browser preflight request
        if HTTP.method(req) == "OPTIONS"

            return HTTP.Response(
                200,
                [
                    "Access-Control-Allow-Origin" => "*",
                    "Access-Control-Allow-Methods" => "GET, POST, OPTIONS",
                    "Access-Control-Allow-Headers" => "Content-Type"
                ]
            )

        end


        # Execute the actual Oxygen route
        response = handler(req)


        # Add CORS headers to existing response
        push!(
            response.headers,
            "Access-Control-Allow-Origin" => "*"
        )

        push!(
            response.headers,
            "Access-Control-Allow-Methods" => "GET, POST, OPTIONS"
        )

        push!(
            response.headers,
            "Access-Control-Allow-Headers" => "Content-Type"
        )

        return response

    end

end

@get "/health" function (req::HTTP.Request)

    return Dict(
        "Status" => "Good"
    )

end

@post "/design/column" function (req::HTTP.Request)

    body = JSON3.read(String(req.body))

    Length = Float64(body.Length)

    Fac_Axial_Load =
        Float64(body.Fac_Axial_Load)

    Boundary_Condition =
        Int(body.Boundary_Condition)

    Sections =
        String(body.Sections)


    result = Design_Column(
        Length,
        Fac_Axial_Load,
        Boundary_Condition,
        Sections
    )

    return result

end

serve(
    middleware=[
        cors_handler
    ]
)