backend default {
	.host = "localhost";
	.port = "81";
}

sub vcl_recv {
	if (req.http.x-forwarded-for) {
		set req.http.X-Forwarded-For = req.http.X-Forwarded-For ", " client.ip;
	} else {
		set req.http.X-Forwarded-For = client.ip;
	}
	if (req.request != "GET" &&
	  req.request != "HEAD" &&
	  req.request != "PUT" &&
	  req.request != "POST" &&
	  req.request != "TRACE" &&
	  req.request != "OPTIONS" &&
	  req.request != "DELETE") {
		/* Non-RFC2616 or CONNECT which is weird. */
		return (pipe);
	}

	// remove has_js and google analytics cookies
	set req.http.Cookie = regsuball(req.http.Cookie, "(^|;\s*)(__[a-z]+|has_js)=[^;]*", "");

	// remove a ";" prefix, if present
	set req.http.Cookie = regsub(req.http.Cookie, "^;\s*", "");

	// remove empty cookies
	if (req.http.Cookie ~ "^\s*$") {
		unset req.http.Cookie;
	}

	// Normalize the Accept-Encoding header
	if (req.http.Accept-Encoding) {
		if (req.url ~ "\.(jpg|png|gif|gz|tgz|bz2|tbz|mp3|ogg)$") {
			// no point in compressing these
			remove req.http.Accept-Encoding;
		}
	} elsif (req.http.Accept-Encoding ~ "gzip") {
		set req.http.Accept-Encoding = "gzip";
	} elsif (req.http.Accept-Encoding ~ "deflate") {
		set req.http.Accept-Encoding = "deflate";
	} else {
		// unknown algorithm
		remove req.http.Accept-Encoding;
	}

	// only cache GET and HEAD requests
	if (req.request != "GET" && req.request != "HEAD") {
		return (pass);
	}

	// anything with cookies or authorization should not be cached
	if (req.http.Authorization || req.http.Cookie) {
		return (pass);
	}
}
