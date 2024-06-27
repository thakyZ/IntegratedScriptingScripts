[CmdletBinding()]
Param(
  [Parameter(Mandatory = $False,
             Position = 0,
             ValueFromPipeline = $True,
             HelpMessage = "Path to a minecraft instance with IntegratedScripting installed and one SinglePlayer save.")]
  [Alias("Path", "LiteralPath", "PSPath")]
  [System.String]
  $MinecraftPath = $Null
)

Begin {
  If ([System.String]::IsNullOrEmpty($MinecraftPath)) {
    $MinecraftPath = (Read-Host -Prompt "Path to minecraft folder (See help for info)");
    $MinecraftPath = $ExecutionContext.InvokeCommand.ExpandString($MinecraftPath);
  }

  $TypingFileEndPath = (Join-Path -Path "integratedscripting" -ChildPath "integratedscripting.d.ts");

  $OutputPath = $Null;

  If ($PSVersionTable.PSVersion.Major -le 5) {
    $OutputPath = (Join-Path -Path $PSScriptRoot -ChildPath (Join-Path -Path "typings" -ChildPath "integratedscripting.d.ts"));
  } Else {
    $OutputPath = (Join-Path -Path $PSScriptRoot -ChildPath "typings" -AdditionalChildPath "integratedscripting.d.ts");
  }
} Process {
  $Path = (Get-Item -Path $MinecraftPath);
  $SavesPath = (Get-Item -Path (Join-Path -Path $Path -ChildPath "saves"));
  $Saves = (Get-ChildItem -Path $SavesPath -Directory);
  $TypingFilePath = $Null;
  ForEach ($Save in $Saves) {
    If ([System.String]::IsNullOrEmpty($TypingFilePath)) {
      $TypingFilePath = (Join-Path -Path $Save -ChildPath $TypingFileEndPath);
    }

    If (-not (Test-Path -Path $TypingFilePath)) {
      $TypingFilePath = $Null;
    }
  }

  If ([System.String]::IsNullOrEmpty($TypingFilePath)) {
    $ErrorPath = $Null;
    If ($PSVersionTable.PSVersion.Major -le 5) {
      $ErrorPath = (Join-Path -Path $SavesPath -ChildPath (Join-Path -Path "<save>" -ChildPath $TypingFileEndPath));
    } Else {
      $ErrorPath = (Join-Path -Path $SavesPath -ChildPath "<save>" -AdditionalChildPath @($TypingFileEndPath));
    }
    Throw "Failed to find the IntegratedScripting typing file at `"$($ErrorPath)`".";
  }
} End {
  New-Item -Path $OutputPath -ItemType SymbolicLink -Value $TypingFilePath | Out-Null;
}