package utils

func Find[T comparable](s []T, e T) T {
	for _, v := range s {
		if v == e {
			return v
		}
	}
	var def T

	return def
}
