param()

$workspace = "e:/Projects/ecommerce_dw_project"
$src = Join-Path $workspace "src/data_generator/java_generator"
$out = Join-Path $workspace "build/data_generator/java_generator"

$package = "src.data_generator.java_generator.Main"

Write-Host "Workspace: $workspace"
Write-Host "Source: $src"
Write-Host "Build: $out"

# -----------------------------
# 1 CLEAN
# -----------------------------
Write-Host "Cleaning build directory..."

if (Test-Path $out) {
    Remove-Item $out -Recurse -Force
}

New-Item -ItemType Directory -Path $out | Out-Null

# -----------------------------
# 2 COMPILE
# -----------------------------
Write-Host "Compiling Java sources..."

& javac -encoding UTF-8 -d $out (Join-Path $src "*.java")

$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Host "Compilation failed with exit code $exitCode"
    exit $exitCode
}

Write-Host "Compilation succeeded."

# -----------------------------
# 3 RUN
# -----------------------------
Write-Host "Running Java program..."

& java -cp $out $package

$runCode = $LASTEXITCODE

if ($runCode -eq 0) {
    Write-Host "Program finished successfully."
}
else {
    Write-Host "Program exited with code $runCode"
}

exit $runCode