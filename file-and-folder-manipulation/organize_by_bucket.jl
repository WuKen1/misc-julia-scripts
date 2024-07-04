# recreate title_to_bucket dictionary from txt files
regex_bucket = r"(?<!.)anchira\.to_\d+(001)*-\d+000\.txt(?!.)";
recovery_files = filter(x -> occursin(regex_bucket, x), readdir("anchira_recovery"));
txt_to_str_vector(file) = split(open(io->read(io,String), file), '\n');

title_to_bucket = Dict([(title, splitext(bucket)[1])
                        for bucket in recovery_files
                        for title in txt_to_str_vector(joinpath("anchira_recovery",
                                                                bucket))]);

# create bucket folders
mkpath("anchira.to_1-1000");
mkpath.(["anchira.to_$i" * "001-$(i+1)" * "000" for i=1:13]);

for (root, ~, files) in walkdir("anchira")
    for file in files
        ~haskey(title_to_bucket, file) && continue # abort if key not found in dict
        src = joinpath(root, file);
        dst = joinpath(".", title_to_bucket[file], file);
        src == dst && continue # abort if source and destination are the same
        try
            mv(src, dst; force=true); # move file to appropriate bucket
        catch e
            println("something went wrong with:\n$file\n$e\n");
        end
    end
end