package org.isetn;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;


@RestController

public class FormationController {
	@Autowired
	private FormationRepository formationRepository;
	
@PostMapping("/addF")
public Formation addF(@RequestBody Formation formation) {
	        return formationRepository.save(formation);
	}
@PostMapping("/allF")
public List<Formation> allF(@RequestBody Formation formation) {
	        return formationRepository.findAll();
	}
@PostMapping("/createForm")
public Formation Create(@RequestBody Formation formation) {
	        return formationRepository.save(formation);
	}
@PostMapping("/updateForm")

public Formation updateFormation(@RequestBody Formation form) {
	return formationRepository.save(form);
	}

}
