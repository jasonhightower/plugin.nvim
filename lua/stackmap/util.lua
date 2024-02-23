-- to reload a package you can call
-- lua package.loaded["<module name">] = nil
-- ie: lua package.loaded["stackmap.util"] = nil
-- next require will reload the file
-- TODO: setup a keymap to set all plugin packages to nil in order to force a reload
print("Utils loaded")
