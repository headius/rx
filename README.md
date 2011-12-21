What Is It
==========

RX is a pure-Ruby XML parser written by Tim Bray, in an
effort to make an alternative to REXML.

Status
======

The code is largely unchanged from when Tim wrote it
several years ago. I (@headius) have made a few small
optimizations.

Currently, the benchmark (test/bench.rb) indicates that
on JRuby, RX runs about 10% slower than REXML for parsing
a large XML file On Ruby 1.9.2, the ratio is above 2x.

Plans
=====

I post this mostly to see if there's interest in getting a
better pure-Ruby XML parser alternative to the
much-maligned, inaccurate, buggy REXML currently shipped
in Ruby's standard library.

Getting performance on par with REXML is the first
priority. If we can't make a real parser (i.e. one that
will actually reject bad XML) that matches REXML's
performance (heavily Regexp-driven), then there's no
chance. I believe we can.

Once it looks like performance can match REXML, we would
want to fill out remaining functionality and perhaps try
to match REXML's user-facing APIs.

Commit rights will be given freely to anyone who wants to
work on this.

Tim says: I have some cycles. I'm sort of out of ideas on
how-to-make-it-run-fast, but if someone can break through 
that logjam, I'd commit to maintaining the automaton DSL
and actual XML-specific code; even adding proper entity 
support (yecch).  And XPath support.
