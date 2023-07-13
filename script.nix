{
  stdenv,
  writeText,
  writeShellScriptBin,
  app,
}:
let 
  pythonScript = writeText "pythonScript.py" ''
      import sys
      from iavl.utils import encode_stdint
      import binascii
      print("0x%s" % binascii.hexlify(encode_stdint(int(sys.argv[1]))).decode('ascii'))
    '';
in {
  fix_discrepancies = writeShellScriptBin "fix_discrepancies.sh" ''
    set -e
    # [[ -z "$1" || -z "$2" ]] && echo "Usage: $0 <db path> <height> Error: missing db path or height" && exit 1
    hex_height=$(${app}/bin/python3 ${pythonScript} $1)
    env
    echo $hex_height
    # ldb --db=$1 put "s/latest" $hex_height --value_hex
  '';
}