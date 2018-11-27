from invoke import task


@task
def enc(ctx, file='local.env', encoded_file='env.ci'):
    ctx.run("openssl aes-256-cbc -e -in {} -out {} -k $FEEDYARD_PIPELINE_KEY".format(file, encoded_file))

@task
def dec(ctx, encoded_file='env.ci', file='local.env'):
    ctx.run("openssl aes-256-cbc -d -in {} -out {} -k $FEEDYARD_PIPELINE_KEY".format(encoded_file, file))

@task
def buildlocal(ctx):
    ctx.run("docker build -t local/circleci-orb-agent:latest .")

@task
def testlocal(ctx):
    ctx.run("bash testlocal.sh")
