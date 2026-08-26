# Cipher

### in the root directory fire up the virtual env
for linux
```bash
source venv/bin/activate
```
To run the backend
run inside the Backend folder
```bash
    julia index.jl
```
then install the Julia and Oxygen.jl 
```bash
    ##fire julia in cmd only inside the venv
    julia
    using Pkg
    Pkg.add("Oxygen")
```
## The csv files for steel table and all IS table shall be in ./Backend/CSV_Data

## Testing column design
Test example
```bash
# curl -X POST http://127.0.0.1:8080/design/column \
#   -H "Content-Type: application/json" \
#   -d '{
#     "Length": 3.0,
#     "Fac_Axial_Load": 500.0,
#     "Boundary_Condition": 0,
#     "Sections": "I"
#   }'
```