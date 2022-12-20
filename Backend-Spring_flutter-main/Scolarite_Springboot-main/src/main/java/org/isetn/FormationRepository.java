package org.isetn;



import org.springframework.data.jpa.repository.JpaRepository;
/*import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;*/
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
@RepositoryRestResource
public interface FormationRepository extends JpaRepository<Formation, Long> {
	//@Query("select p from Etudiant e where e.nom like :x")
	//public List<Etudiant> Chercher(@Param("x")String nom);
	//ou d'ecrire 
}
