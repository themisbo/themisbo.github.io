### A Pluto.jl notebook ###
# v0.16.0

using Markdown
using InteractiveUtils

# ╔═╡ 65c609be-2533-11ec-2020-6b6774892850
using PlutoUI, CSV, DataFrames, HTTP

# ╔═╡ be39bcf7-442a-4033-aa7e-59fcd4076187
html"""<h1>Data analysis of the billboard 100 data</h1>"""

# ╔═╡ 724b1eef-a386-48f2-b8e3-8487d7ee8d93
md"""This document is part of the showcase, where I replicate the same brief and simple analyses with different tools.

This particular file focuses on data analysis (a few queries) of the billboard 100 data from the tidytuesday project.

The data can be found in https://github.com/rfordatascience/tidytuesday/tree/master/data/2021/2021-09-14. They consist of two documents: billboard.csv contains information about the songs focusing on their position in the top100 list at different weeks. audio_features.csv contains information about specific attributes of the songs from spotify.

For the specific analysis I will use Julia and DataFrames (plus Pluto notebook).

We start by loading the packages:"""

# ╔═╡ b7a4eeef-f473-4edf-a6e9-f8378e8e06a8
md"""and the billboard datset:"""

# ╔═╡ d63d223d-2cfc-4e99-b461-924a061a359d
html_billboard = 
"https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-14/billboard.csv"

# ╔═╡ 606b48b3-e9c3-4988-ac63-3e0fb23dc4ce
billboard = CSV.read(IOBuffer(HTTP.get(html_billboard).body), DataFrame)

# ╔═╡ 133aff07-805d-45e7-9b59-937ab2144cbf
md"""We can have a look at the schema of the billboard data column names:"""

# ╔═╡ 82ee46dc-6bb1-4e42-a9d5-6dfdf0f03775
propertynames(billboard)

# ╔═╡ 15ac908d-536c-42bd-b2cb-7725dc0b7478
md"""column types:"""

# ╔═╡ 8c849c6c-9631-48ce-ae2a-bb1e5b2aa1f9
eltype.(eachcol(billboard))

# ╔═╡ 8a7e85fa-d19d-4db9-a678-1dcc39963bdf
md"""and summary statistics:"""

# ╔═╡ 5788e2a2-fc10-48d4-9bec-6f67510f228c
describe(billboard)

# ╔═╡ a619f031-6242-428d-9047-880531dde984
md"""For the first main query, our aim is to select only the songs that have reached the No 1 spot of the billboard and see how many weeks they have stayed at the billboard in total:"""

# ╔═╡ 217356ed-5dd6-4dc5-87c3-1d973251670e
top10 = filter(:peak_position => peak_position -> peak_position ==1, billboard)

# ╔═╡ 49d282ac-7dcf-4f55-837f-0db4a75f883b
select!(top10, Not([:url, :peak_position, :previous_week_position]))

# ╔═╡ 309b346d-a9bc-4676-bb7e-2dfb43f20be7
top10a = combine(groupby(top10,[:performer,:song]),:weeks_on_chart=>maximum=>:max_weeks)

# ╔═╡ 42b51b71-e09b-40d5-8fad-1ae1c1966fc0
sort!(top10a, :max_weeks, rev = true)

# ╔═╡ 92893b05-9d30-425a-b49c-0730e963ce97
first(top10a,10)

# ╔═╡ 430cff96-c69e-4201-b8d0-61c73b1e8327
md"""Now we load the audio features dataset:"""

# ╔═╡ 0e5af95f-6784-4d41-8adc-ad3257c3aa42
html_audio = 
"https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-09-14/audio_features.csv"

# ╔═╡ 37cf7988-7ff6-49bf-a416-f48aa25049e9
audio_features = CSV.read(IOBuffer(HTTP.get(html_audio).body), DataFrame)

# ╔═╡ 5907712d-217e-4346-8e27-11f055514ce9
md"""And once again we look at the summary statistics:"""

# ╔═╡ 459ba1cc-0177-4a74-a0a9-16443dd1c695
describe(audio_features)

# ╔═╡ ff251902-f6fc-4034-8874-a0cffc323f28
md"""For the second main query, our aim is to derive information about the peak position a song has reached in the billboard and the main spotify information. For this, we need to join the two datasets:"""

# ╔═╡ ec860cdd-a70d-49e2-8144-09c392eec561
left_join = combine(groupby(billboard,[:performer,:song,:song_id]),:peak_position=>maximum=>:best_position)

# ╔═╡ d2d07573-535d-4aec-b27e-845c29f9e564
right_join = select(audio_features, [:song_id, :spotify_genre, :danceability, :energy, :key, :loudness, :speechiness, :acousticness, :instrumentalness, :liveness, :valence, :tempo])

# ╔═╡ 38b3b953-26b9-4c40-bd8b-465de83dc499
data_join = innerjoin(left_join, right_join, on = :song_id)

# ╔═╡ 2f8e82e3-51a6-4149-9680-096c4fed2019
sort!(data_join, :performer)

# ╔═╡ cfe70661-6b57-4554-a39c-c29d4dc31118
first(data_join,10)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
HTTP = "cd3eb016-35fb-5094-929b-558a96fad6f3"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CSV = "~0.9.6"
DataFrames = "~1.2.2"
HTTP = "~0.9.16"
PlutoUI = "~0.7.14"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "567d865fc5702dc094e4519daeab9e9d44d66c63"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.9.6"

[[CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "31d0151f5716b655421d9d75b7fa74cc4e744df2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.39.0"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d785f42445b63fc86caa08bb9a9351008be9b765"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.2.2"

[[DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "7d9d316f04214f7efdbb6398d545446e246eff02"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.10"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FilePathsBase]]
deps = ["Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "7fb0eaac190a7a68a56d2407a6beff1142daf844"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.12"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "14eece7a3308b4d8be910e265c724a6ba51a9798"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.16"

[[HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[IniFile]]
deps = ["Test"]
git-tree-sha1 = "098e4d2c533924c921f9f9847274f2ad89e018b8"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.0"

[[InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "19cb49649f8c41de7fea32d089d37de917b553da"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.0.1"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "a8709b968a1ea6abc2dc1967cb1db6ac9a00dfb6"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.5"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["Base64", "Dates", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "d1fb76655a95bf6ea4348d7197b22e889a4375f4"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.14"

[[PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a193d6ad9c45ada72c14b731a318bedd3c2f00cf"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.3.0"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "69fd065725ee69950f3f58eceb6d144ce32d627d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.2"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "54f37736d8934a12a200edea2f9206b03bdf3159"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.7"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "c69f9da3ff2f4f02e811c3323c22e5dfcb584cfa"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.1"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═be39bcf7-442a-4033-aa7e-59fcd4076187
# ╠═724b1eef-a386-48f2-b8e3-8487d7ee8d93
# ╠═65c609be-2533-11ec-2020-6b6774892850
# ╠═b7a4eeef-f473-4edf-a6e9-f8378e8e06a8
# ╠═d63d223d-2cfc-4e99-b461-924a061a359d
# ╠═606b48b3-e9c3-4988-ac63-3e0fb23dc4ce
# ╠═133aff07-805d-45e7-9b59-937ab2144cbf
# ╠═82ee46dc-6bb1-4e42-a9d5-6dfdf0f03775
# ╠═15ac908d-536c-42bd-b2cb-7725dc0b7478
# ╠═8c849c6c-9631-48ce-ae2a-bb1e5b2aa1f9
# ╠═8a7e85fa-d19d-4db9-a678-1dcc39963bdf
# ╠═5788e2a2-fc10-48d4-9bec-6f67510f228c
# ╠═a619f031-6242-428d-9047-880531dde984
# ╠═217356ed-5dd6-4dc5-87c3-1d973251670e
# ╠═49d282ac-7dcf-4f55-837f-0db4a75f883b
# ╠═309b346d-a9bc-4676-bb7e-2dfb43f20be7
# ╠═42b51b71-e09b-40d5-8fad-1ae1c1966fc0
# ╠═92893b05-9d30-425a-b49c-0730e963ce97
# ╠═430cff96-c69e-4201-b8d0-61c73b1e8327
# ╠═0e5af95f-6784-4d41-8adc-ad3257c3aa42
# ╠═37cf7988-7ff6-49bf-a416-f48aa25049e9
# ╠═5907712d-217e-4346-8e27-11f055514ce9
# ╠═459ba1cc-0177-4a74-a0a9-16443dd1c695
# ╠═ff251902-f6fc-4034-8874-a0cffc323f28
# ╠═ec860cdd-a70d-49e2-8144-09c392eec561
# ╠═d2d07573-535d-4aec-b27e-845c29f9e564
# ╠═38b3b953-26b9-4c40-bd8b-465de83dc499
# ╠═2f8e82e3-51a6-4149-9680-096c4fed2019
# ╠═cfe70661-6b57-4554-a39c-c29d4dc31118
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
