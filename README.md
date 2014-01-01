iMessageFormatter
=================

An Applescript to autoformat sentences with a capital letter and period at the end

If you provide a sentence such as:
`joe and I went to the market`
It will format it as:
`Joe and I went to the market.`

If you put in a link (ending in all known tlds), or a filename, it will intentionally not correct it.

Feel free to contribute with more prefixes to ignore. Currently supported are `{"http", "www.", "ftp://", "ftp.", "localhost://"}`
