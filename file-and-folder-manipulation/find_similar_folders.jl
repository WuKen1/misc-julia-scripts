# given two different directories, find all folders that share a common name

function convert_bytes(size; from, to)
    # conversion_factor_to_bytes
    function Ω(unit)
        if unit == "bit"
            return 1/8
        elseif unit == "byte"
            return 1
        elseif unit == "kb"
            return 1000
        elseif unit == "mb"
            return 1000^2
        elseif unit == "gb"
            return 1000^3
        else
            return nothing
        end
    end
    convert_to_bytes(x; unit) = x * Ω(unit)
    convert_from_bytes(x; unit) = x * Ω(unit)^-1

    intermediate = convert_to_bytes(size; unit=from)
    return convert_from_bytes(intermediate; unit=to)
end

function folder_basename(root)
    index = findlast('\\', root);
    return index === nothing ? root : root[index+1:end];
end

folder_filesize(dir) = sum([files .|> (x->joinpath(root,x)) .|> filesize |> sum
                            for (root, dirs, files) in walkdir(dir)]);

dirs_of(dir) = dir |> readdir .|> (x->joinpath(dir,x)) |> filter(isdir);
files_of(dir) = dir |> readdir .|> (x->joinpath(dir,x)) |> filter(isfile);

function is_subdirectory_of(;parent, child)
    for (root, dirs, files) in walkdir(parent)
        if root == child &&
        map(x->joinpath(root,x), dirs) == dirs_of(child) &&
        map(x->joinpath(root,x), files) == files_of(child)
            return true
        end
    end
    return false
end

println("\ntype in 1st directory:");
dir1 = readline();
println("\n");

println("type in 2nd directory:");
dir2 = readline();
println("\n");

# TO-DO: collect results, filter out redundant results? e.g. subfolder match is found before "superfolder"

HOLD_THE_1ST_DIRECTORY_FIXED = true;

if ~HOLD_THE_1ST_DIRECTORY_FIXED
    exclude1 = Set(); exclude2 = Set();
    for (root1, ~, ~) in walkdir(dir1; topdown=true)
        root1 in exclude1 && continue
        any(y->is_subdirectory_of(child=root1,parent=y), exclude1) && continue
        for (root2, ~, ~) in walkdir(dir2; topdown=true)
            root2 in exclude2 && continue
            any(y->is_subdirectory_of(child=root2,parent=y), exclude2) && continue

            if folder_basename(root1) == folder_basename(root2) &&
            abs(folder_filesize(root1) - folder_filesize(root2)) < convert_bytes(0.25; from="mb", to="byte")
                push!(exclude1, root1)
                push!(exclude2, root2)
                println(root1);
                println(root2);
                println("\n");
            end
        end
    end
else
    exclude2 = Set();
    root1 = dir1
    for (root2, ~, ~) in walkdir(dir2; topdown=true)
        root2 in exclude2 && continue
        any(y->is_subdirectory_of(child=root2,parent=y), exclude2) && continue
    
        if folder_basename(root1) == folder_basename(root2) &&
        abs(folder_filesize(root1) - folder_filesize(root2)) < convert_bytes(0.25; from="mb", to="byte")
            push!(exclude1, root1)
            push!(exclude2, root2)
            println(root1);
            println(root2);
            println("\n");
        end
    end
end

# explicit iteration version
#=
function folder_filesize(dir)
    total_size = 0;
    for (root, dirs, files) in walkdir(dir)
        for file in files
            total_size += filesize(joinpath(root,file))
        end
    end
    return total_size;
end
=#