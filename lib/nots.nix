{ lib }:
{
  mkProgramPath =
    {
      hasHomeManager,
      dotUsername,
      program,
    }:
    if hasHomeManager then
      [
        "home-manager"
        "users"
        dotUsername
        "programs"
        program
      ]
    else
      [
        "programs"
        program
      ];

  mkProgramConfig =
    {
      hasHomeManager,
      dotUsername,
      program,
      attrs,
    }:
    lib.setAttrByPath (
      if hasHomeManager then
        [
          "home-manager"
          "users"
          dotUsername
          "programs"
          program
        ]
      else
        [
          "programs"
          program
        ]
    ) attrs;
}
