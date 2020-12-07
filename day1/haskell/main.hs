convertStringToInt :: String -> Int
convertStringToInt xs = read xs :: Int

is2020 :: [Int] -> Bool
is2020 xs = 2020 == sum xs

solve1 :: [Int] -> Int
solve1 xs = product (head (filter is2020 [[x, y] | x <- xs, y <- xs]))

solve2 :: [Int] -> Int
solve2 xs = product (head (filter is2020 [[x, y, z] | x <- xs, y <- xs, z <- xs]))

main = do
	contents <- lines <$> readFile "../input"
	let num_contents = map convertStringToInt contents
	let solution = solve1 num_contents
	print solution
	let solution = solve2 num_contents
	print solution