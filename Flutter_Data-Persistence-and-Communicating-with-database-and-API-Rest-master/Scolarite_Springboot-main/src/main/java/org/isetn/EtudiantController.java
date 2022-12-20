package org.isetn;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

public class EtudiantController {
@Autowired
private EtudiantRepository etudiantRepository;
@PostMapping("/all")
public List<Etudiant> allF(@RequestBody Etudiant etudiant) {
		        return etudiantRepository.findAll();
		}
@PostMapping("/add")
public Etudiant Create(@RequestBody Etudiant etudiant) {
		        return etudiantRepository.save(etudiant);
		}
}
