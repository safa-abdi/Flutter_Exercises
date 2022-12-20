package org.isetn;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurerAdapter;

@Configuration
public class GlobalRepositoryRestConfigurer extends RepositoryRestConfigurerAdapter {
	@Override
	public void configureRepositoryRestConfiguration(RepositoryRestConfiguration repositoryRestConfiguration) {
		repositoryRestConfiguration.setReturnBodyOnCreate(true);
		repositoryRestConfiguration.setReturnBodyOnUpdate(true);

		repositoryRestConfiguration.exposeIdsFor(Etudiant.class, Formation.class);
		repositoryRestConfiguration.exposeIdsFor(Etudiant.class, Classe.class);
		repositoryRestConfiguration.getCorsRegistry()
		.addMapping("/**")
		// pour le test on met
		//.allowedOrigins("http://localhost:4200")
		//pour le test on met
		.allowedOrigins("*")
		.allowedHeaders("*")
		.allowedMethods("OPTIONS","HEAD", "GET", "PUT", "POST", "DELETE", "PATCH" );

	}

}
