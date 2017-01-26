package org.eclipse.m2m.atl.atlgt.projector;

import org.eclipse.emf.common.util.URI;

/**
 * ???
 */
public interface Projector {

    /**
     * ???
     *
     * @param module ???
     *
     * @return ???
     */
    URI transform(URI module);
}
